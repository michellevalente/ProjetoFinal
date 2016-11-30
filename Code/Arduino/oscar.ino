#include <SoftwareSerial.h>
#include <SPI.h>
#include <boards.h>
#include <RBL_nRF8001.h>
#include "Servo.h"

#define MAX_CODE        100
#define SERVO_LEFT      10
#define SERVO_RIGHT     5
#define LED_BLUE        6
#define LED_RED         7
#define BUZZER          4
#define BLOCK_THRESH    20
#define TRIG            2
#define ECHO            3

typedef enum ReactionType {
  GENERIC     = 0,
  SENSOR      = 1,
  TIMER       = 2,
} ReactionType;

typedef struct Reaction {
  ReactionType type;
  char code[MAX_CODE];
  int codeLen;
  int codePos;
  int loopPos;
  long wait;
  boolean isTurning;
} Reaction;

struct Reaction newReaction() {
  Reaction r;
  r.type    =  GENERIC;
  r.codeLen =  0;
  r.codePos =  0;
  r.loopPos = -1;
  r.wait    =  0;
  r.isTurning = false;
  return r;
}

boolean receivingCode = true;
boolean recvReact = false;
int blockCount = 0;
Reaction reactions[2];
int nReactions  = 1;
int curReaction = 0;
Servo servoLeft;                             
Servo servoRight;

void setServo(int speedLeft, int speedRight)
{
  servoLeft.writeMicroseconds(1500 + speedLeft);  
  servoRight.writeMicroseconds(1500 - speedRight);                                   
}

void servo_setup() {
  servoLeft.attach(SERVO_LEFT);                      
  servoRight.attach(SERVO_RIGHT); 
}

void setWait(Reaction* r, unsigned long now, unsigned long interval) {
  r->wait = now + interval;
}

boolean runCode(Reaction* r) {
  int i;
  long now = millis();
  
  if (r->wait > now)
    return true;
  else {
    r->wait = 0;
    if (r->isTurning) {
      setServo(0,0);
      r->isTurning = false;
    }  
  }

  if (r->codePos < r->codeLen) { 
      char command[5];
      for (i = 0; i < 4; i++)
        command[i] = r->code[(r->codePos)++];
       command[i] = '\0';
       
      if (strcmp(command, "loop") == 0) { // loop
         r->loopPos = r->codePos;
      }
      else if (strcmp(command, "ledr") == 0) { // red led
        digitalWrite(LED_RED, r->code[(r->codePos)++] == '1' ? HIGH : LOW); 
      }
      else if (strcmp(command, "ledb") == 0) { // blue led
        digitalWrite(LED_BLUE, r->code[(r->codePos)++] == '1' ? HIGH : LOW); 
      }
      else if(strcmp(command,"buzz") == 0) { // buzzer
        int timer;
        sscanf(r->code + r->codePos, "%d", &timer);
        r->codePos += floor(log10(abs(timer))) + 1;
        tone(BUZZER, 1500, timer);     
      } 
      else if(strcmp(command,"wait") == 0) { // wait
        int timer;
        sscanf(r->code + r->codePos, "%d", &timer);
        r->codePos += floor(log10(abs(timer))) + 1;
        setWait(r, now, timer);
      }
      else if(strcmp(command,"move") == 0) { // move
        if(r->code[(r->codePos)++] == '1')
          setServo(-200, -200);
        else
          setServo(200, 200);
        setWait(r, now, 1500);
        r->isTurning = true;
      }
      else if(strcmp(command,"turn") == 0) { // turn
        if(r->code[(r->codePos)++] == '0') {
          setServo(-200, 200);
          setWait(r, now, 1500);
        }
        else {
          setServo(200, -200);
          setWait(r, now, 1500);
        }
        r->isTurning = true;
      }
      else if(strcmp(command,"stop") == 0) { // stop
        setServo(0,0);
        setWait(r, now, 20);
      }
      
      return true;
  }

  else if (r->loopPos >= 0) {
    r->codePos = r->loopPos; 
    return true;
  }
  
  return false; // program ended
}


void setup() {
  pinMode(LED_RED, OUTPUT);  
  pinMode(LED_BLUE, OUTPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  servo_setup();
  ble_begin();
  Serial.begin(9600);
  resetState();
}

void resetState() {
  receivingCode = true;
  recvReact     = true;
  curReaction   = 0;
  nReactions    = 1; 
  reactions[0]  = newReaction();
  blockCount = 0;
  for(int i = 0; i < MAX_CODE; i++)
    reactions[0].code[i] = '\0';
}

int checkReactions() {
  int i, reactionIdx = 0;
  
  for (i = 1; i < nReactions; i++) {
    // Check if car is blocked
    ReactionType type = reactions[i].type;
    if (type == SENSOR && blockCount >= BLOCK_THRESH){
        reactionIdx = i;
        blockCount = 0;
    }
    // Check time reaction 
    else if (type = TIMER) {
      if (reactions[i].wait == -1 || reactions[i].wait != 0 && millis() > reactions[i].wait)
        reactionIdx = i;
    }

    // If a reaction was found, leave
    if (reactionIdx)
      break;
  }

  return reactionIdx;
}

void loop() {
  char codeChar;

  // Receive code from app, if any available
  if (ble_available()) {
    if(!receivingCode)
      resetState();

    Reaction* recv = &(reactions[nReactions - 1]);
    codeChar = (char)ble_read();
    
    // End of the receiving code
    if (codeChar == '/')
      receivingCode = false;  
    // New reaction
    else if (codeChar == '|') {
      nReactions++;
      reactions[nReactions-1] = newReaction();
      for(int i = 0; i < MAX_CODE; i++)
        reactions[nReactions-1].code[i] = '\0';
      recvReact = true;
    }
    else {
      // The first char should set the type of the reaction
      if (recvReact) {
        switch (codeChar) {
          case '1':{
            Serial.println("Received sensor");
            recv->type = SENSOR; 
            break;
          }
          case '2': {
            Serial.println("Received timer");
            recv->type = TIMER;
            recv->wait = -1;
            break;
          }
          default:  recv->type = GENERIC;
        }
        recvReact = false;
      } 
      // Part of a command
      else
        recv->code[(recv->codeLen)++] = codeChar;
    }
    
    Serial.println(recv->code);
  }

  // Check for blocking
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(1000);
  digitalWrite(TRIG, LOW);
  int duration = pulseIn(ECHO, HIGH);
  int distance = (duration/2) / 29.1;
  if(map(distance, 0, 45, 8, 0) >= 8)
    blockCount +=1;
  
  boolean isAlive, timerFirstRun = false;
  
  // All the code received
  if (!receivingCode) {
    
    // Check if there is a reaction to execute
    if (curReaction == 0)
      curReaction = checkReactions();

    // If reaction is of the type Timer and is being run by the 
    // first time, set the control flag
    if (reactions[curReaction].type == TIMER && reactions[curReaction].codePos == 0)
      timerFirstRun = true;

    isAlive = runCode(&(reactions[curReaction]));
  }
  
  if (timerFirstRun) {
    curReaction = 0;
  }
  
  // Code has finished, so clean code
  else if (!isAlive) {
    if (curReaction) {
      reactions[curReaction].codePos = 0;
      reactions[curReaction].wait = 0;
      reactions[curReaction].isTurning = false;
      curReaction = 0; // return to main trail 
    }
    else
      resetState();
  }
  
  ble_do_events();
  
}
