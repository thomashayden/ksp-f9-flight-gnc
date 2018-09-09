// Objectives
// ====================================
// - Fly to 1.8m
// - 3 second flight duration

// Vehicle
// ====================================
// F9R
// - Side engines removed (only center engine remaining)
// - Grid fins removed
// - Landing legs lowered
// - Fuel reduced to lowest level
// - Launch clamp added to allow the vehicle to spawn with its legs at the right level

// Constants
// ====================================
// Flight specific
SET flightAltitude TO 1.8.
SET minThrottle TO 0.37066. // or .37066
// The global throttle value (0, 1). Cannot use all that range, only down to minThrottle
SET glbThrottle TO 0.
// Converts an engine throttle percentage to the throttle range on the nav ball
LOCK adjThrottle TO (glbThrottle - minThrottle) / (1 - minThrottle).
// Lock the throttle controls to the adjusted throttle. To change the throttle, set the global
// throttle to a value between 0 and 1
LOCK THROTTLE TO adjThrottle.

// Track max altitude
SET maxAlt TO 0.


// General
LOCK grv TO BODY:MU / (SHIP:ALTITUDE + BODY:RADIUS)^2.
LOCK twr TO SHIP:MAXTHRUST / (SHIP:MASS * grv).

// Check the current radar reading to account for the offset
// ISSUES: the radar reads from the center of mass -> changes during flight
SET radarOffset TO ALT:RADAR.
LOCK adjAlt TO ALT:RADAR - radarOffset.

// Track the current program position
SET step TO 0.
// Track time
SET t0 TO 0.

WAIT 1.

// Preflight operations
// ====================================
// Nothing the computer needs to do.
// Before flight the clamps should be released, the engines enabled, and SAS on.


SET done TO false.
UNTIL done {
  //LOCK twr TO SHIP:MAXTHRUST / (SHIP:MASS * grv).

  CLEARSCREEN.
  PRINT "Grasshopper flight 1 (T+ " + (TIME:SECONDS - t0) + ")" AT (0,0).
  PRINT "====================" AT (0,1).
  PRINT "Adjusted altitude: " + adjAlt AT (0,2).
  PRINT "Current TWR: " + twr AT (0,3).
  PRINT "Global Throttle: " + glbThrottle AT (0,4).
  PRINT "Max Altitude: " + maxAlt AT (0,5).

  IF adjAlt > maxAlt {
    SET maxAlt TO adjAlt.
  }

  IF step = 0 { // Upward movement
    IF t0 = 0 { // Start the timer if it hasn't already been started
      SET t0 TO TIME:SECONDS.
    }
    LOCK glbThrottle TO 1.0 / twr * 1.2. // Run engines at 1.2Gs of thrust
    IF adjAlt >= flightAltitude / 3 { // At 1/3 of the flightAltitude, stop accelerating upward
      SET step TO 1.
    }
  }
  IF step = 1 { // Downward movement
    LOCK glbThrottle TO 1.0 / twr * 0.8. // Run engines at 0.8Gs of thrust
    IF adjAlt <= 0.1 { // When pretty much on the ground, stop.
      SET step TO 2.
    }
  }
  IF step = 2 {
    SET done TO true.
    SET glbThrottle TO 0.
  }

  WAIT 0.01.
}
