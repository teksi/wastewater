# arm builds are not available with 3.2
#FROM imresamu/postgis-arm64:14-3.2-alpine AS base-arm64
FROM imresamu/postgis-arm64:16-3.5-alpine AS base-arm64

FROM postgis/postgis:16-3.5-alpine AS base-amd64

FROM base-$BUILDARCH AS common
