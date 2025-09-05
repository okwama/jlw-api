# JLW Foundation API Server

A NestJS-based API server for the JLW Foundation Flutter application.

## Features

- **User Management**: CRUD operations for users
- **Notice Board**: Manage foundation notices and announcements
- **Dashboard**: Real-time statistics and data for the home screen
- **Bursary Management**: Handle bursary applications and payments
- **Ambulance Services**: Manage ambulance requests
- **MySQL Integration**: Direct connection to your remote MySQL database

## Quick Start

### Prerequisites

- Node.js 18+ 
- npm or yarn
- MySQL database access

### Installation

1. Install dependencies:
```bash
npm install
```

2. Create environment file:
```bash
cp .env.example .env
```

3. Configure your database credentials in `.env`:
```env
DB_HOST=102.218.215.35
DB_PORT=3306
DB_USERNAME=citlogis_bryan
DB_DB_PASSWORD=@bo9511221.qwerty
DB_DATABASE=citlogis_foundation
NODE_ENV=development
```

### Development

```bash
# Start development server
npm run start:dev

# Build for production
npm run build

# Start production server
npm run start:prod
```

## API Endpoints

### Dashboard
- `GET /api/v1/dashboard/stats` - Get dashboard statistics
- `GET /api/v1/dashboard/today-events` - Get today's events
- `GET /api/v1/dashboard/user-profile/:userId` - Get user profile
- `GET /api/v1/dashboard/recent-notices` - Get recent notices
- `GET /api/v1/dashboard/home-data` - Get all home screen data

### Users
- `GET /api/v1/users` - Get all users
- `GET /api/v1/users/:id` - Get user by ID
- `POST /api/v1/users` - Create new user
- `PUT /api/v1/users/:id` - Update user
- `DELETE /api/v1/users/:id` - Delete user

### Notices
- `GET /api/v1/notices` - Get all notices
- `GET /api/v1/notices/:id` - Get notice by ID
- `POST /api/v1/notices` - Create new notice
- `PUT /api/v1/notices/:id` - Update notice
- `DELETE /api/v1/notices/:id` - Delete notice

## Deployment to Vercel

1. Install Vercel CLI:
```bash
npm i -g vercel
```

2. Deploy:
```bash
vercel --prod
```

3. Set environment variables in Vercel dashboard:
   - `DB_HOST`
   - `DB_PORT`
   - `DB_USERNAME`
   - `DB_PASSWORD`
   - `DB_DATABASE`

## Database Schema

The server connects to your existing MySQL database with tables:
- `User` - User management
- `NoticeBoard` - Foundation notices
- `BursaryPayment` - Bursary records
- `AmbulanceRequest` - Ambulance services
- And more...

## Security

- CORS enabled for Flutter app
- Input validation with class-validator
- Environment-based configuration
- SQL injection protection via TypeORM

## Support

For issues or questions, contact the development team.
