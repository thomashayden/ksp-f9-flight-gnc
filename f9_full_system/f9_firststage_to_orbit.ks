// Parameters for the flight
SET tApoapsis TO 35786000.
SET tPeriapsis TO 35786000.

SET thrott TO 0.
SET steer TO HEADING(90,90).

LOCK throttle TO thrott.
LOCK steering TO steer.

SET landingTarget TO SHIP:GEOPOSITION.
SET radarOffset to 50.000.
LOCK trueRadar TO alt:radar - radarOffset.

CLEARSCREEN.

//Pre-flight checks
IF ADDONS:TR:AVAILABLE = FALSE {
  PRINT "THIS IS NOT GOOD!!! TRAJECTORIES IS NOT WORKING!!!".
}

// Initial firing of the engines and release of the clamps
SET thrott TO 1.
STAGE. // Start engines
WAIT 3.
STAGE. // Release clamps
SET launchTime TO TIME:SECONDS.
LOCK t TO TIME:SECONDS - launchTime.

SET pitchLookupTable TO READJSON("pitch_lookup_table.json").

// The gravity turn of the first stage
UNTIL STAGE:KEROSENE < 20000 OR STAGE:LQDOXYGEN < 20000 OR APOAPSIS >= tApoapsis {
  //SET tPitch TO MAX(5, 90 * (1 - (ALT:RADAR + 850) / 47000)).
  //SET steer TO HEADING(90, tPitch).
  SET targetPitch TO pitchLookupTable[ROUND(t)].
  SET currentPitch TO 90 - VANG(UP:VECTOR, SHIP:FACING:FOREVECTOR).
  SET currentProgradePitch TO 90 - VANG(SHIP:SRFPROGRADE:VECTOR, UP:VECTOR).
  SET steer TO HEADING(90, targetPitch).
  SET pitchDifference TO targetPitch - currentProgradePitch.
  //SET thrott TO 0.9 + (pitchDifference / 100).
  SET thrott TO 1 - SHIP:Q.
  PRINT "T+ " + t AT (0,0).
  PRINT "Q: " + SHIP:Q AT (0,1).
  PRINT "Throttle: " + thrott AT (0,2).
  PRINT "Actual Throttle: " + throttle AT (0,3).
  PRINT "Current Pitch: " + currentPitch AT(0,4).
  PRINT "Target Pitch: " + targetPitch AT (0,5).
  PRINT "Prograde Pitch: " + currentProgradePitch AT (0,6).
  PRINT "Angle: " + pitchDifference AT (0,7).
}

SET thrott TO 0.

WAIT 3.

SET message TO "activate-" + tPeriapsis + "-" + tApoapsis.
SET p TO PROCESSOR("f9s2").
IF P:CONNECTION:SENDMESSAGE(MESSAGE) {
  PRINT "Sent: " + message.
}

WAIT 20.

IF ADDONS:TR:HASIMPACT = FALSE {
  PRINT "Uh-oh! Trajectories doesn't have an impact for some reason.".
}

// Boostback
UNTIL landingTarget:LNG >= ADDONS:TR:IMPACTPOS:LNG {
  SET steer TO HEADING(90,180).
  SET thrott TO 0.3.
}
SET thrott TO 0.

BRAKES on.

LIST ENGINES in engines.

FOR engine IN engines {
  SET engine:thrustlimit TO 0.
}
SET SHIP:PARTSTAGGED("center_engine")[0]:thrustlimit TO 100.

SET stoppingDistance TO ((SHIP:VERTICALSPEED)^2) / (2 * ((SHIP:AVAILABLETHRUST / SHIP:MASS) - (CONSTANT:G * BODY:MASS / BODY:RADIUS^2))).

WAIT UNTIL trueRadar < 10000.
WAIT UNTIL trueRadar <= stoppingDistance + (ABS(SHIP:VERTICALSPEED) * 3).
UNTIL trueRadar / ABS(SHIP:VERTICALSPEED) < 3 {
  SET steer TO SRFRETROGRADE.
  SET thrott TO stoppingDistance / trueRadar.
}
GEAR on.
UNTIL trueRadar < 0.5 OR (SHIP:VERTICALSPEED > -0.5 AND GOINFORIT = 1) {
  SET steer TO SRFRETROGRADE.
  SET thrott TO stoppingDistance / trueRadar.
}
SET thrott TO 0.
WAIT 1.
