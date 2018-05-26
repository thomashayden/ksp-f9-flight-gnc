@lazyglobal off.

RUN ONCE lib_navball.

GLOBAL cutOff TO 0.5.

FUNCTION maxMomentum {
  PARAMETER distance.

  RETURN LN(ABS(distance) + 1) * 50.
}

FUNCTION react {
  PARAMETER diff.

  RETURN LN(ABS(diff) + 1) / 15 + 0.01.
}

FUNCTION counteract {
  PARAMETER value.

  RETURN getSign(value) * (LN(ABS(value) + 1) / 18 + 0.05).
}

FUNCTION cancelPitchMomentum {
  PARAMETER pShip.
  LOCAL rotation IS pShip:ANGULARMOMENTUM.
  LOCAL pitch IS rotation:X.
  LOCAL counterPitch IS counteract(pitch).

  IF ABS(pitch) < cutoff {
    SET counterPitch TO 0.
  }
  RETURN counterPitch.
}

FUNCTION cancelYawMomentum {
  PARAMETER pShip.
  LOCAL rotation IS pShip:ANGULARMOMENTUM.
  LOCAL yaw IS rotation:Z.
  LOCAL counterYaw IS counteract(yaw).

  IF ABS(yaw) < cutoff {
    SET counterYaw TO 0.
  }
  RETURN counterYaw.
}

FUNCTION cancelRollMomentum {
  PARAMETER pShip.
  LOCAL rotation IS pShip:ANGULARMOMENTUM.
  LOCAL roll IS rotation:Y.
  LOCAL counterRoll IS counteract(roll).

  IF ABS(roll) < cutoff {
    SET counterRoll TO 0.
  }
  RETURN counterRoll.
}

FUNCTION cancelMomentum {
  PARAMETER pShip.

  LOCAL rotation IS pShip:ANGULARMOMENTUM.
  LOCAL pitch IS rotation:X.
  LOCAL roll IS rotation:Y.
  LOCAL yaw IS rotation:Z.

  LOCAL counterPitch IS cancelPitchMomentum(pShip).
  LOCAL counterYaw IS cancelYawMomentum(pShip).
  LOCAL counterRoll IS cancelRollMomentum(pShip).

  CLEARSCREEN.
  PRINT "Pitch: " + pitch AT (0,1).
  PRINT "Yaw: " + yaw AT (0,2).
  PRINT "Roll: " + roll AT (0,3).
  PRINT "Counter Pitch: " + counterPitch AT (0,4).
  PRINT "Counter Yaw: " + counterYaw AT (0,5).
  PRINT "Counter Roll: " + counterRoll AT (0,6).
  RETURN V(counterYaw, counterPitch, counterRoll).
}

FUNCTION targetPitch {
  PARAMETER pShip.
  PARAMETER tPitch.

  LOCAL pitch IS pitch_for(pShip).
  LOCAL pitchMomentum IS pShip:ANGULARMOMENTUM:X.
  LOCAL distance IS tPitch - pitch.

  //PRINT "Hello." AT (0,13).

  //IF pitchMomentum > 0 {
  //  RETURN 0.2.
  //} ELSE {
  //  RETURN -0.2.
  //}

  //PRINT "     " AT (0,10).
  //PRINT "     " AT (0,11).
  //PRINT "       " AT (0,12).
  IF maxMomentum(distance) > ABS(pitchMomentum) {
    //PRINT "HERE!" AT (0,10).
    RETURN (getSign(pitchMomentum) * getSign(distance)) * -1 * getSign(pitchMomentum) * react(distance).
  } ELSE IF maxMomentum(distance) * 1.1 < ABS(pitchMomentum) {
    //PRINT "NOPE!" AT (0, 11).
    RETURN (getSign(pitchMomentum) * getSign(distance)) * getSign(pitchMomentum) * react(distance).
  } ELSE {
    //PRINT "Yeah..." AT (0,12).
    RETURN 0.
  }
}

FUNCTION targetYaw {
  PARAMETER pShip.
  PARAMETER tYaw.

  LOCAL yaw IS compass_for(pShip).
  LOCAL yawMomentum IS pShip:ANGULARMOMENTUM:Z.
  LOCAL distance IS tYaw - yaw.

  //IF pitchMomentum > 0 {
  //  RETURN 0.2.
  //} ELSE {
  //  RETURN -0.2.
  //}

  IF maxMomentum(distance) > ABS(yawMomentum) {
    RETURN (getSign(yawMomentum) * getSign(distance)) *  getSign(yawMomentum) * react(distance).
  } ELSE IF maxMomentum(distance) * 1.1 < ABS(yawMomentum) {
    RETURN (getSign(yawMomentum) * getSign(distance)) * -1 * getSign(yawMomentum) * react(distance).
  } ELSE {
    RETURN 0.
  }
}

FUNCTION targetRoll {
  PARAMETER pShip.
  PARAMETER tRoll.

  LOCAL roll IS roll_for(pShip).
  LOCAL rollMomentum IS pShip:ANGULARMOMENTUM:Y.
  LOCAL distance IS tRoll - roll.

  //IF pitchMomentum > 0 {
  //  RETURN 0.2.
  //} ELSE {
  //  RETURN -0.2.
  //}

  IF maxMomentum(distance) / 10 > ABS(rollMomentum) {
    RETURN (getSign(rollMomentum) * getSign(distance)) * getSign(rollMomentum) * react(distance).
  } ELSE IF maxMomentum(distance) / 10 * 1.1 < ABS(rollMomentum) {
    RETURN (getSign(rollMomentum) * getSign(distance)) * -1 * getSign(rollMomentum) * react(distance).
  } ELSE {
    RETURN 0.
  }
}

FUNCTION isStopped {
  PARAMETER pShip.
  LOCAL rotation IS pShip:ANGULARMOMENTUM.
  LOCAL pitch IS rotation:X.
  LOCAL roll IS rotation:Y.
  LOCAL yaw IS rotation:Z.

  if (ABS(pitch) > cutOff OR ABS(roll) > cutOff OR ABS(yaw) > cutOff) {
    RETURN false.
  }
  RETURN true.
}

FUNCTION pointAt {
  PARAMETER pShip.
  PARAMETER tPitch.
  PARAMETER tYaw.
  PARAMETER tRoll.

  UNTIL NOT TERMINAL:INPUT:HASCHAR() {
    TERMINAL:INPUT:GETCHAR().
  }

  UNTIL isStopped(pShip) OR TERMINAL:INPUT:HASCHAR() {
    SET pShip:CONTROL:ROTATION TO cancelMomentum(pShip).
  }
  PRINT "PRESS ANY KEY!!!".
  TERMINAL:INPUT:GETCHAR().

  // Release the controls
  SET pShip:CONTROL:NEUTRALIZE TO TRUE.

  CLEARSCREEN.
  PRINT "NEXT SECTION!".
  UNTIL TERMINAL:INPUT:HASCHAR() {
    //CLEARSCREEN.
    PRINT "Pitch: " + pitch_for(pShip) AT (0,1).
    PRINT "Yaw: " + compass_for(pShip) AT (0,2).
    PRINT "Roll: " + roll_for(pShip) AT (0,3).
    PRINT "Pitch react: " + targetPitch(pShip, 45) AT (0,4).
    PRINT "Pitch distance: " + (45 - pitch_for(pShip)) AT (0,5).
    PRINT "Pitch momentum: " + pShip:ANGULARMOMENTUM:X AT (0,6).
    PRINT "Yaw react: " + targetYaw(pShip, 45) AT (0,7).
    PRINT "Yaw distance: " + (45 - compass_for(pShip)) AT (0,8).
    PRINT "Yaw momentum: " + pShip:ANGULARMOMENTUM:Z AT (0,9).
    PRINT "Roll react: " + (-1 * targetRoll(pShip, 45)) AT (0,10).
    PRINT "Roll distance: " + (45 - roll_for(pShip)) AT (0,11).
    PRINT "Roll momentum: " + pShip:ANGULARMOMENTUM:Y AT (0,12).

    SET pShip:CONTROL:ROTATION TO V(0, targetPitch(pShip, 45), 0).
  }

  SET pShip:CONTROL:NEUTRALIZE TO TRUE.
}

FUNCTION getSign {
  PARAMETER x.
  if x < 0 {
    RETURN -1.
  } else {
    RETURN 1.
  }
}
