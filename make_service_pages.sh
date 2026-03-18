#!/bin/bash
# ============================================================
# make_service_pages.sh
# Run from the ROOT of your Jekyll project.
# Creates all 100 service-area stub pages.
# Usage: bash make_service_pages.sh
# ============================================================

SERVICES=(
  transmission-repair
  transmission-replacement
  transmission-maintenance
  transmission-flush
  cvt-transmission-service
  clutch-repair
  engine-repair
  engine-rebuild
  auto-engine-diagnostic
  automotive-diagnostics
  check-engine-light
  ac-installation-repair
  auto-ac-recharge
  auto-ac-replacement
  auto-electrical-repair
  battery-testing-replacement
  diesel-engines
  auto-brake-repair
  steering-suspension-repair
  wheel-alignment
  adas-calibration
  general-repairs-maintenance
  auto-exhaust-system-repair
  engine-diagnostics
  air-conditioning
)

CITIES=(
  mount-dora-fl
  tavares-fl
  leesburg-fl
  clermont-fl
)

COUNT=0

for CITY in "${CITIES[@]}"; do
  for SVC in "${SERVICES[@]}"; do
    DIR="service-areas/${CITY}/${SVC}"
    mkdir -p "$DIR"
    FILE="${DIR}/index.html"
    if [ ! -f "$FILE" ]; then
      cat > "$FILE" <<EOF
---
layout: service-areas
city_slug: ${CITY}
service_slug: ${SVC}
---
EOF
      COUNT=$((COUNT + 1))
      echo "Created: $FILE"
    else
      echo "Skipped (exists): $FILE"
    fi
  done
done

echo ""
echo "Done. $COUNT pages created."
