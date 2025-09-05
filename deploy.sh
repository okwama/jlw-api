#!/bin/bash

echo "🚀 Deploying JLW Foundation API to Vercel..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

# Build the project
echo "🔨 Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully"
else
    echo "❌ Build failed"
    exit 1
fi

# Deploy to Vercel
echo "🌐 Deploying to Vercel..."
vercel --prod

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Deployment completed successfully!"
    echo ""
    echo "📋 Your API is now live on Vercel!"
    echo "🔗 Update your Flutter app's remote_database_service.dart with the new API URL"
    echo ""
    echo "💡 Don't forget to set environment variables in Vercel dashboard:"
    echo "   - DB_HOST"
    echo "   - DB_PORT" 
    echo "   - DB_USERNAME"
    echo "   - DB_PASSWORD"
    echo "   - DB_DATABASE"
else
    echo "❌ Deployment failed"
    exit 1
fi
