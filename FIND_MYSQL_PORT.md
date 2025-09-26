# How to Find Your MySQL Port

## Method 1: Check if MySQL is Running and Find Port

### On Mac/Linux:
```bash
# See what's using port 3306 (default MySQL port)
lsof -i :3306

# Or check what port MySQL is using
ps aux | grep mysql
```

### On Windows:
```cmd
# Check if port 3306 is in use
netstat -an | findstr :3306

# Check MySQL process
tasklist | findstr mysql
```

## Method 2: Check MySQL Configuration

### For Standard MySQL Installation:
```bash
# Connect to MySQL
mysql -u root -p

# Once connected, run:
SHOW VARIABLES WHERE Variable_name = 'port';
```

### For XAMPP Users:
1. **Mac**: Check `/Applications/XAMPP/xamppfiles/etc/my.cnf`
2. **Windows**: Check `C:\xampp\mysql\bin\my.ini`
3. **Linux**: Check `/opt/lampp/etc/my.cnf`

Look for the `port` setting under `[mysqld]` section.

## Method 3: XAMPP Control Panel
1. Open XAMPP Control Panel
2. Look at the MySQL module - it often shows the port number
3. Or click on "Config" → "my.ini" or "my.cnf" for MySQL

## Common MySQL Ports:
- **3306** - Default MySQL port (standard installations)
- **3307** - Common XAMPP MySQL port (to avoid conflicts)
- **3308** - Sometimes used when multiple MySQL instances exist

## Quick Test:
Try connecting with different ports:
```bash
# Try default port
mysql -u root -h 127.0.0.1 -P 3306 -e "SELECT 1"

# Try XAMPP port
mysql -u root -h 127.0.0.1 -P 3307 -e "SELECT 1"
```

The one that works is your MySQL port!

## Setting Up This Project:
Once you know your port:
1. Copy `.env.example` to `.env`
2. Set `DB_PORT=YOUR_PORT_HERE`
3. Run `npm start`