// Parameters for the flight
SET tApoapsis TO 200000.
SET tPeriapsis TO 150000.

SET thrott TO 0.
SET steer TO HEADING(90,90).

LOCK throttle TO thrott.
LOCK steering TO steer.

CLEARSCREEN.

// Initial firing of the engines and release of the clamps
SET thrott TO 1.
STAGE. // Start engines
WAIT 0.6.
STAGE. // Release clamps

// The gravity turn of the first stage
UNTIL STAGE:LIQUIDFUEL < 0.1 OR APOAPSIS >= tApoapsis {
  SET tPitch TO MAX(5, 90 * (1 - (ALT:RADAR + 850) / 47000)).
  SET steer TO HEADING(90, tPitch).
  SET thrott TO 1 - SHIP:Q.
  PRINT "Q: " + SHIP:Q AT (0,0).
  PRINT "Throttle: " + (1 - SHIP:Q) AT (0,1).
}

SET message TO "activate-" + tPeriapsis + "-" + tApoapsis.
SET p TO PROCESSOR("f9s2").
IF P:CONNECTION:SENDMESSAGE(MESSAGE) {
  PRINT "Sent: " + message.
}
