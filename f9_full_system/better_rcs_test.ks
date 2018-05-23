RUN ONCE better_rcs.

UNTIL TERMINAL:INPUT:HASCHAR() {
  pointAt(SHIP, 90, 0, 0).
}

// Release all the ship controls.
SET SHIP:CONTROL:NEUTRALIZE TO TRUE.
