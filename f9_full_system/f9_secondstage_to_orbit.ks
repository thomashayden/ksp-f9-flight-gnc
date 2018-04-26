CLEARSCREEN.
PRINT "Waiting for signal from stage 1".

SET steer TO SHIP:FACING:VECTOR.
LOCK STEERING TO steer.

WAIT UNTIL NOT CORE:MESSAGES:EMPTY.
SET recieved TO CORE:MESSAGES:POP.
SET recievedSplit TO recieved:CONTENT:SPLIT("-").
// Takes a message, the periapsis, and the apoapsis
IF recievedSplit:LENGTH() = 3 AND recievedSplit[0] = "activate" {
  STAGE. // Stage-sep?
  PRINT "Stage number 1".
  WAIT 3.
  STAGE. // Activate engine?
  PRINT "Stage number 2".
  //WAIT 2.
  //STAGE. // Deploy fairing
  //PRINT "Stage number 3".

  PRINT "Message recieved. Beginning program.".
  SET tPeriapsis TO recievedSplit[1]:TONUMBER().
  SET tApoapsis TO recievedSplit[2]:TONUMBER().

  UNLOCK steering.
  SAS on.
  WAIT 0.5.
  SET SASMODE TO "PROGRADE".
  LOCK THROTTLE TO 1.
  WAIT UNTIL APOAPSIS >= tApoapsis.
  LOCK THROTTLE TO 0.
  SAS off.
  LOCK steering TO steer.

  SET mu TO BODY:MU.
  SET radius TO BODY:RADIUS.
  SET sVelocity TO VELOCITY:ORBIT:MAG.
  SET r TO radius + ALTITUDE.
  SET a TO radius + APOAPSIS.
  SET v1 TO SQRT(sVelocity^2 + 2 * mu * (1 / a - 1 / r)).

  SET sma1 TO (PERIAPSIS + 2 * radius + APOAPSIS) / 2.

  SET r2 TO radius + APOAPSIS.
  SET sma2 TO (tPeriapsis + 2 * radius + APOAPSIS) / 2.
  SET v2 TO SQRT(sVelocity^2 + (mu * (2 / r2 - 2 / r + 1 / sma1 - 1 / sma2))).

  SET deltav TO v2 - v1.
  SET nd TO NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, deltav).
  ADD nd.

  SET n TO NEXTNODE.

  SET a0 TO MAXTHRUST / MASS.
  SET eIsp TO 0.
  LIST engines IN myEngines.
  FOR engine IN myEngines {
    SET eIsp To eIsp + engine:MAXTHRUST / MAXTHRUST * engine:ISP.
  }
  SET ve TO eISP * 9.82.
  SET finalMass TO MASS * CONSTANT:e ^ (-1 * n:BURNVECTOR:MAG / ve).
  SET a1 TO MAXTHRUST / finalMass.
  SET t TO n:BURNVECTOR:MAG / ((a0 + a1) / 2).
  SET startTime TO TIME:SECONDS + n:ETA - t / 2.
  SET endTime TO TIME:SECONDS + n:ETA + t / 2.

  UNLOCK STEERING.
  SAS on.
  WAIT 0.01.
  SET SASMODE TO "MANEUVER".

  WAIT UNTIL startTime - TIME:SECONDS < 10 OR VANG(SHIP:FACING:VECTOR, n:BURNVECTOR) < 0.5.

  WAIT UNTIL TIME:SECONDS >= startTime.
  LOCK THROTTLE TO 1.
  WAIT UNTIL TIME:SECONDS >= endTime.
  LOCK THROTTLE TO 0.

  SAS off.

} ELSE {
  PRINT "Unexpected message: " + recieved:CONTENT.
}
