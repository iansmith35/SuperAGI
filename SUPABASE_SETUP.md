# Supabase Integration Guide for ISHE Group AI Platform

## Overview
This guide explains how to integrate Supabase as the persistent database and memory store for the ISHE Group AI Platform.

## Prerequisites
1. A Supabase account (sign up at https://supabase.com)
2. A new Supabase project created

## Step 1: Create Supabase Project

1. Go to https://supabase.com/dashboard
2. Click "New Project"
3. Enter project details:
   - Name: `ishe-group-ai`
   - Database Password: (save this securely)
   - Region: Choose closest to your Railway deployment
4. Wait for project initialization (~2 minutes)

## Step 2: Get Connection Details

From your Supabase project dashboard:

### Database Connection
1. Go to Settings → Database
2. Copy the **Connection String** (URI format):
   ```
   postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   ```
3. Replace `[PASSWORD]` with your database password

### API Credentials
1. Go to Settings → API
2. Copy:
   - **Project URL**: `https://[PROJECT-REF].supabase.co`
   - **anon public key**: For client-side operations
   - **service_role key**: For server-side operations (keep secret!)

## Step 3: Configure Railway Environment Variables

Add these to your Railway project (Variables section):

```bash
# Supabase Database
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

# Supabase API
SUPABASE_URL=https://[PROJECT-REF].supabase.co
SUPABASE_KEY=[YOUR-SERVICE-ROLE-KEY]

# Enable Supabase features
ENABLE_SUPABASE_MEMORY=True
```

## Step 4: Initialize Database Schema

The platform will auto-create tables via Alembic migrations when deployed. However, you can manually run the initial schema:

### Connect to Supabase SQL Editor:
1. Open your Supabase project
2. Go to SQL Editor
3. Run the migration scripts in order (from `/migrations/versions/`)

Or use the automated script:
```bash
python scripts/run_migrations.py
```

## Step 5: Create Agent Memory Tables (Optional)

For enhanced agent memory persistence:

```sql
-- Agent Memory Store
CREATE TABLE IF NOT EXISTS agent_memories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  agent_id INTEGER NOT NULL,
  agent_execution_id INTEGER,
  memory_type VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  embedding VECTOR(1536),
  metadata JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for vector similarity search
CREATE INDEX IF NOT EXISTS agent_memories_embedding_idx 
ON agent_memories USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- Create index for agent queries
CREATE INDEX IF NOT EXISTS agent_memories_agent_id_idx 
ON agent_memories(agent_id);

-- Agent Knowledge Base
CREATE TABLE IF NOT EXISTS agent_knowledge (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  agent_id INTEGER NOT NULL,
  knowledge_type VARCHAR(50) NOT NULL,
  title VARCHAR(255),
  content TEXT NOT NULL,
  embedding VECTOR(1536),
  metadata JSONB,
  source_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE
);

-- Create index for knowledge search
CREATE INDEX IF NOT EXISTS agent_knowledge_embedding_idx 
ON agent_knowledge USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- Enable pgvector extension (required for vector operations)
CREATE EXTENSION IF NOT EXISTS vector;

-- Enable full-text search
CREATE EXTENSION IF NOT EXISTS pg_trgm;
```

## Step 6: Configure Row Level Security (RLS)

For production deployments, enable RLS:

```sql
-- Enable RLS on agent tables
ALTER TABLE agent_memories ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_knowledge ENABLE ROW LEVEL SECURITY;

-- Allow service role full access
CREATE POLICY "Service role has full access to agent_memories"
ON agent_memories FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

CREATE POLICY "Service role has full access to agent_knowledge"
ON agent_knowledge FOR ALL
TO service_role
USING (true)
WITH CHECK (true);
```

## Step 7: Set Up Realtime (Optional)

Enable realtime updates for agent activity monitoring:

```sql
-- Enable realtime for specific tables
ALTER PUBLICATION supabase_realtime ADD TABLE agent_memories;
ALTER PUBLICATION supabase_realtime ADD TABLE agent_executions;
```

## Step 8: Configure Storage Buckets (Optional)

For file storage (agent resources, outputs):

1. Go to Storage in Supabase dashboard
2. Create buckets:
   - `agent-inputs` - For agent input files
   - `agent-outputs` - For agent generated files
   - `agent-resources` - For shared resources

3. Set bucket policies:
```sql
-- Allow authenticated uploads
CREATE POLICY "Allow service role uploads"
ON storage.objects FOR INSERT
TO service_role
WITH CHECK (bucket_id IN ('agent-inputs', 'agent-outputs', 'agent-resources'));
```

## Verification

Test your connection:

```python
# Test script (run locally)
import os
from supabase import create_client, Client

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)

# Test connection
response = supabase.table('agents').select("*").limit(1).execute()
print("Connection successful!" if response else "Connection failed")
```

## Monitoring

Monitor your Supabase usage:
1. Database size: Settings → Database → Database size
2. API requests: Home → API requests chart
3. Database connections: Settings → Database → Connection pooling

## Best Practices

1. **Use connection pooling**: Supabase provides built-in pooling
2. **Regular backups**: Enable automatic backups in Project Settings
3. **Monitor costs**: Set up billing alerts in Supabase dashboard
4. **Security**: Never commit credentials; use Railway environment variables
5. **Performance**: Use indexes for frequently queried columns
6. **Scaling**: Consider upgrading Supabase tier as usage grows

## Troubleshooting

### Connection Timeouts
- Check Railway→Supabase network connectivity
- Verify DATABASE_URL format
- Ensure password doesn't contain special characters (URL encode if needed)

### Migration Errors
- Run migrations manually via Supabase SQL Editor
- Check Alembic version table: `SELECT * FROM alembic_version;`

### Memory Persistence Issues
- Verify ENABLE_SUPABASE_MEMORY=True
- Check agent_memories table exists
- Review application logs in Railway

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Connection Pooling](https://supabase.com/docs/guides/database/connecting-to-postgres#connection-pooler)
- [Supabase Vector Extension](https://supabase.com/docs/guides/ai/vector-columns)
- [Railway + Supabase Integration](https://docs.railway.app/databases/postgresql)

---

**Need Help?** Check the ISHE Group AI Platform documentation or create an issue in the repository.
