# Team 2 Deployment Information

Based on the official team spreadsheet, here are the correct configurations for Team 2:

## Team Members
- Rameau, Elvis, Jonathan, Mike, Bonheur

## Deployment Paths
- **Frontend Path**: `/var/www/html/seiv2025/p2/t2`
- **Backend Path**: `nodeapps/2025/project2/t2`

## Database Configuration
- **DB User**: `t22025`
- **DB Password**: `CS@oc2025t2`
- **DB Schema/Name**: `course-t2`
- **DB Host**: (Need from instructor - likely `t2-database.czjofbims6cw.us-west-2.rds.amazonaws.com`)

## API Configuration
- **Node Port**: `3012`
- **REST API Path**: `/course-t2`

## GitHub Secrets Required
```yaml
# Backend Repository Secrets
SERVER_SSH_KEY: (Get from instructor)
DB_HOST: (Get from instructor)
DB_USER: t22025
DB_PW: CS@oc2025t2
DB_NAME: course-t2  # Note: This is the schema name from spreadsheet
DB_PORT: 3306

# Frontend Repository Secrets
SERVER_SSH_KEY: (Same as backend)
```

## Production URLs
- **Frontend**: https://project2.eaglesoftwareteam.com/seiv2025/p2/t2/
- **Backend API**: https://project2.eaglesoftwareteam.com/course-t2/

## Important Notes
1. The database name is `course-t2` NOT `t22025` (that's the username)
2. All paths use 2025, not 2024
3. Service name pattern follows instructor's examples