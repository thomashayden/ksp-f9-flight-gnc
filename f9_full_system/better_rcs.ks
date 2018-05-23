@lazyglobal off.

GLOBAL cutOff To 0.1.

FUNCTION cancelMomentum {
  PARAMETER pShip.
  LOCAL rotation IS pShip:ANGULARMOMENTUM.
  LOCAL pitch IS rotation:X.
  LOCAL roll IS rotation:Y.
  LOCAL yaw IS rotation:Z.

  LOCAL counterPitch IS getSign(pitch) * LN(ABS(pitch) + 1) / 18.
  LOCAL counterYaw IS getSign(yaw) * LN(ABS(yaw) + 1) / 18.
  LOCAL counterRoll IS getSign(roll) * LN(ABS(roll) + 1) / 18.

  if ABS(pitch) < cutoff {
    SET counterPitch TO 0.
  }
  if ABS(yaw) < cutoff {
    SET counterYaw TO 0.
  }
  if ABS(roll) < cutoff {
    SET counterRoll TO 0.
  }
  CLEARSCREEN.
  PRINT "Pitch: " + pitch AT (0,1).
  PRINT "Yaw: " + yaw AT (0,2).
  PRINT "Roll: " + roll AT (0,3).
  PRINT "Counter Pitch: " + counterPitch AT (0,4).
  PRINT "Counter Yaw: " + counterYaw AT (0,5).
  PRINT "Counter Roll: " + counterRoll AT (0,6).
  RETURN V(counterYaw, counterPitch, counterRoll).
}

FUNCTION isStopped {
  PARAMETER pShip.
  LOCAL rotation IS pShip:ANGULARMOMENTUM.
  LOCAL pitch IS rotation:X.
  LOCAL roll IS rotation:Y.
  LOCAL yaw IS rotation:Z.

  if (pitch > cutOff OR roll > cutOff OR yaw > cutOff) {
    RETURN false.
  }
  RETURN true.
}

FUNCTION pointAt {
  PARAMETER pShip.
  PARAMETER tPitch.
  PARAMETER tYaw.
  PARAMETER tRoll.

  UNTIL isStopped(pShip) OR TERMINAL:INPUT:HASCHAR() {
    SET pShip:CONTROL:ROTATION TO cancelMomentum(pShip).
  }
  // Release the controls
  SET SHIP:CONTROL:NEUTRALIZE TO TRUE.

  UNTIL false {
    CLEARSCREEN.
    PRINT "Pitch: " + SHIP:FACING:PITCH AT (0,1).
    PRINT "Yaw: " + SHIP:FACING:YAW AT (0,2).
    PRINT "Roll: " + SHIP:FACING:ROLL AT (0,3).
  }
}

FUNCTION getSign {
  PARAMETER x.
  if x < 0 {
    RETURN -1.
  } else {
    RETURN 1.
  }
}
