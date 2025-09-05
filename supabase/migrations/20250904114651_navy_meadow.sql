/*
  # Create admin and content management tables

  1. New Tables
    - `categories`
      - `id` (integer, primary key)
      - `name` (text, unique)
      - `slug` (text, unique)
      - `description` (text, nullable)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    - `articles`
      - `id` (integer, primary key)
      - `title` (text)
      - `slug` (text, unique)
      - `excerpt` (text, nullable)
      - `content` (text)
      - `featured_image_url` (text, nullable)
      - `category_id` (integer, foreign key)
      - `author` (text, nullable)
      - `is_featured` (boolean)
      - `published_at` (timestamp, nullable)
      - `status` (enum: draft/published)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    - `newsletter_subscribers`
      - `id` (integer, primary key)
      - `email` (text, unique)
      - `subscribed_at` (timestamp)
      - `is_active` (boolean)
    - `contact_messages`
      - `id` (integer, primary key)
      - `name` (text)
      - `email` (text)
      - `subject` (text)
      - `message` (text)
      - `created_at` (timestamp)
      - `is_read` (boolean)
    - `admin_users`
      - `id` (integer, primary key)
      - `user_id` (uuid, foreign key to auth.users)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users and admin access
    - Public read access for published articles and categories
    - Admin-only access for management operations

  3. Sample Data
    - Insert default categories
    - Create sample admin user entry
*/

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create articles table
CREATE TABLE IF NOT EXISTS articles (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  excerpt TEXT,
  content TEXT NOT NULL,
  featured_image_url TEXT,
  category_id INTEGER REFERENCES categories(id),
  author TEXT,
  is_featured BOOLEAN DEFAULT false,
  published_at TIMESTAMPTZ,
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create newsletter subscribers table
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  subscribed_at TIMESTAMPTZ DEFAULT now(),
  is_active BOOLEAN DEFAULT true
);

-- Create contact messages table
CREATE TABLE IF NOT EXISTS contact_messages (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  is_read BOOLEAN DEFAULT false
);

-- Create admin users table
CREATE TABLE IF NOT EXISTS admin_users (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS on all tables
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- Categories policies (public read, admin write)
CREATE POLICY "Anyone can read categories"
  ON categories
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Admins can manage categories"
  ON categories
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE user_id = auth.uid()
    )
  );

-- Articles policies (public read published, admin full access)
CREATE POLICY "Anyone can read published articles"
  ON articles
  FOR SELECT
  TO public
  USING (status = 'published');

CREATE POLICY "Admins can manage all articles"
  ON articles
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE user_id = auth.uid()
    )
  );

-- Newsletter subscribers policies (public insert, admin read)
CREATE POLICY "Anyone can subscribe to newsletter"
  ON newsletter_subscribers
  FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Admins can read subscribers"
  ON newsletter_subscribers
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE user_id = auth.uid()
    )
  );

-- Contact messages policies (public insert, admin read)
CREATE POLICY "Anyone can send contact messages"
  ON contact_messages
  FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Admins can read contact messages"
  ON contact_messages
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can update contact messages"
  ON contact_messages
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE user_id = auth.uid()
    )
  );

-- Admin users policies
CREATE POLICY "Admins can read admin users"
  ON admin_users
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE user_id = auth.uid()
    )
  );

-- Insert default categories
INSERT INTO categories (name, slug, description) VALUES
  ('News', 'news', 'Latest news and current affairs affecting the African diaspora'),
  ('Policy & Migration', 'policy-migration', 'Immigration policies, visa updates, and migration news'),
  ('Culture & Lifestyle', 'culture-lifestyle', 'Cultural events, lifestyle, and community stories'),
  ('Profiles & Voices', 'profiles-voices', 'Personal stories and profiles from the diaspora community'),
  ('Travel & Mobility', 'travel-mobility', 'Travel tips, mobility rights, and destination guides'),
  ('Business & Jobs', 'business-jobs', 'Career opportunities, business news, and entrepreneurship'),
  ('Events', 'events', 'Community events, conferences, and networking opportunities')
ON CONFLICT (slug) DO NOTHING;

-- Insert sample articles
INSERT INTO articles (title, slug, excerpt, content, featured_image_url, category_id, author, is_featured, status, published_at) VALUES
  (
    'Germany Expands Chancenkarte Program: What It Means for African Migrants in 2025',
    'germany-expands-chancenkarte-program-2025',
    'New opportunities emerge as Germany''s points-based immigration system opens doors for skilled workers from Africa.',
    'Germany has announced significant expansions to its Chancenkarte (Opportunity Card) program, creating new pathways for skilled African workers to enter the German job market. The program, which uses a points-based system similar to Canada''s Express Entry, now includes additional criteria that benefit applicants from African countries.

Key changes include:
- Increased points for multilingual abilities, particularly for French and Portuguese speakers
- Recognition of additional African educational institutions
- Streamlined application process for healthcare and IT professionals
- Extended job search period from 12 to 18 months

This expansion comes as Germany faces critical labor shortages in key sectors, with over 2 million job vacancies across the country. The government estimates that the expanded program could attract an additional 50,000 skilled workers annually, with a significant portion expected from African countries.

For African diaspora communities already in Europe, this presents opportunities for family reunification and career advancement. The program also includes provisions for spouses and dependent children, making it an attractive option for families.

Application requirements include:
- Recognized degree or professional qualification
- Minimum German language proficiency (A1 level)
- Proof of financial resources (€2,208 per month)
- Clean criminal record
- Health insurance coverage

The application process can be initiated from African countries or from within the EU for those already residing in Europe. Processing times are expected to be 4-6 weeks for complete applications.',
    'https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=800',
    2,
    'Henry Odhiambo',
    true,
    'published',
    now()
  ),
  (
    'African Entrepreneurs Thrive in Berlin''s Tech Scene',
    'african-entrepreneurs-berlin-tech-scene',
    'Meet the innovators building bridges between Africa and Europe through technology.',
    'Berlin''s startup ecosystem has become a magnet for African entrepreneurs, with over 200 African-founded companies now operating in the German capital. From fintech to e-commerce, these entrepreneurs are not only building successful businesses but also creating bridges between African and European markets.

Notable success stories include:
- Kwame Asante''s fintech startup that facilitates remittances to West Africa
- Amina Hassan''s e-learning platform connecting African students with European universities
- Joseph Mbeki''s logistics company optimizing supply chains between Europe and Africa

The Berlin Senate has launched several initiatives to support African entrepreneurs, including:
- Dedicated incubator programs
- Mentorship networks
- Access to venture capital
- Simplified visa processes for startup founders

These entrepreneurs are contributing significantly to Berlin''s economy while maintaining strong ties to their home countries, creating a unique ecosystem of cross-continental innovation.',
    'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400',
    6,
    'Sarah Kimani',
    true,
    'published',
    now()
  ),
  (
    'Celebrating Afrobeats: How African Music is Reshaping European Culture',
    'afrobeats-reshaping-european-culture',
    'From underground clubs to mainstream festivals, African music continues to influence European cultural landscape.',
    'The rise of Afrobeats in Europe has been nothing short of phenomenal. What started in underground clubs in London, Paris, and Amsterdam has now reached mainstream festivals and radio stations across the continent.

Major European festivals now feature dedicated Afrobeats stages:
- Roskilde Festival (Denmark) - African Music Stage
- Primavera Sound (Spain) - Global Sounds Pavilion
- We Love Green (France) - Afro-European Fusion Stage

The influence extends beyond music:
- Fashion brands incorporating African-inspired designs
- Dance studios offering Afrobeats classes
- Restaurants featuring fusion African-European cuisine
- Art galleries showcasing contemporary African artists

This cultural exchange is creating new opportunities for African artists and entrepreneurs while enriching European cultural diversity. The economic impact is significant, with the African music industry in Europe estimated to be worth over €500 million annually.',
    'https://images.pexels.com/photos/1190298/pexels-photo-1190298.jpeg?auto=compress&cs=tinysrgb&w=400',
    3,
    'Kofi Mensah',
    false,
    'published',
    now()
  )
ON CONFLICT (slug) DO NOTHING;