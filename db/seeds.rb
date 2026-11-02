# frozen_string_literal: true

puts "== Seeding Promptify database =="

# 1. Categories
categories_data = [
  {
    name: "Portraits",
    slug: "portraits",
    position: 1,
    description: "Expressive human and character portraits, lighting setups, lens choices, and candid captures."
  },
  {
    name: "Landscapes",
    slug: "landscapes",
    position: 2,
    description: "Vast natural environments, atmospheric mountain lakes, deserts, forests, and panoramic horizons."
  },
  {
    name: "Architecture",
    slug: "architecture",
    position: 3,
    description: "Brutalist structures, wabi-sabi interiors, modern pavilions, and monumental spaces."
  },
  {
    name: "Sci-Fi & Cyberpunk",
    slug: "sci-fi-cyberpunk",
    position: 4,
    description: "Rain-slicked neon streetscapes, Mars colonies, holographic tech, and retro-futuristic concept art."
  },
  {
    name: "Commercial & Product",
    slug: "commercial-product",
    position: 5,
    description: "Studio lit product hero shots, levitating objects, luxury packaging, and clean e-commerce renders."
  },
  {
    name: "Food & Drink",
    slug: "food-drink",
    position: 6,
    description: "Artisanal culinary photography, steaming bowls, rustic baked goods, and warm ambient kitchen light."
  },
  {
    name: "Abstract & Textures",
    slug: "abstract-textures",
    position: 7,
    description: "Liquid iridescent flows, chrome ribbons, kinetic geometry, and tactile wallpaper renders."
  }
]

categories = {}
categories_data.each do |cat_attrs|
  categories[cat_attrs[:slug]] = Category.find_or_create_by!(slug: cat_attrs[:slug]) do |c|
    c.name = cat_attrs[:name]
    c.position = cat_attrs[:position]
    c.description = cat_attrs[:description]
  end
end

puts "✓ Categories seeded: #{Category.count}"

# 2. Prompts
prompts_data = [
  {
    category_slug: "portraits",
    slug: "golden-hour-portrait",
    title: "Weathered Fisherman in Golden Hour",
    body: "Close-up portrait of an elderly fisherman with weathered skin, deep laugh lines, and a navy knitted wool cap, warm golden hour side lighting, shallow depth of field, 85mm f/1.4 lens, Kodak Portra 400 film grain, warm earthy tones, highly detailed skin texture.",
    negative_prompt: "smooth plastic skin, 3d render, oversaturated, deformed eyes, extra fingers, cartoon, blurry, low resolution",
    ai_model: "Midjourney v6.1",
    aspect_ratio: "4:5",
    image_file: "golden-hour-portrait.jpg"
  },
  {
    category_slug: "portraits",
    slug: "neon-noir-portrait",
    title: "Rain-Soaked Cyber Noir Portrait",
    body: "Cinematic portrait of a young woman standing in a narrow rain-soaked alley at midnight, vivid magenta and cyan neon reflections glistening on wet skin and dark hair, moody film noir atmosphere, soft bokeh from distant city lights, shot on 35mm, high contrast, deep shadows.",
    negative_prompt: "bright flat lighting, washed out colors, anime style, painting, low contrast, oversaturated green, blurry face",
    ai_model: "Flux.1 Pro",
    aspect_ratio: "2:3",
    image_file: "neon-noir-portrait.jpg"
  },
  {
    category_slug: "landscapes",
    slug: "misty-alpine-lake",
    title: "Serene Alpine Lake at Dawn",
    body: "Pristine alpine lake at dawn surrounded by ancient pine forests and jagged snow-capped peaks, low morning mist hovering over mirror-like turquoise water, soft pastel gradient sky with lavender and gold hues, ultra wide angle landscape photography, National Geographic style.",
    negative_prompt: "people, buildings, boats, oversaturated filters, noisy artifacts, watermarks, harsh midday sunlight",
    ai_model: "Midjourney v6.1",
    aspect_ratio: "16:9",
    image_file: "misty-alpine-lake.jpg"
  },
  {
    category_slug: "landscapes",
    slug: "desert-dunes-at-dusk",
    title: "Sahara Dunes at Sunset Caravan",
    body: "Sweeping sand dunes in the Sahara desert at dusk, long dramatic wind-carved shadows, a lone camel caravan silhouetted along the razor-sharp ridge, warm orange and violet gradient sky, minimal composition, cinematic aerial perspective, 8k resolution.",
    negative_prompt: "cars, footprints everywhere, hazy fog, low contrast, washed out sky, plastic sand texture",
    ai_model: "Flux.1 Schnell",
    aspect_ratio: "3:2",
    image_file: "desert-dunes-at-dusk.jpg"
  },
  {
    category_slug: "architecture",
    slug: "brutalist-sanctuary",
    title: "Brutalist Concrete Chapel in Forest",
    body: "Monumental brutalist concrete chapel nestled in a foggy pine forest, dramatic geometric light shafts slicing through narrow monolithic ceiling slits onto polished stone floor, architectural photography, overcast diffused daylight, muted slate and moss palette.",
    negative_prompt: "ornate gothic decorations, busy crowds, sunny bright sky, neon colors, CGI gloss, wide lens distortion",
    ai_model: "Midjourney v6.1",
    aspect_ratio: "4:5",
    image_file: "brutalist-sanctuary.jpg"
  },
  {
    category_slug: "architecture",
    slug: "japanese-tea-house-interior",
    title: "Wabi-Sabi Tea House Interior",
    body: "Minimalist Japanese tea house interior, hand-woven tatami mats, shoji screens diffusing soft morning sunlight, single seasonal ikebana branch in a rustic ceramic vase, wabi-sabi aesthetic, quiet contemplative mood, architectural digest interior photography.",
    negative_prompt: "modern clutter, electronic screens, plastic furniture, harsh flash, dirty floor, messy layout",
    ai_model: "DALL-E 3",
    aspect_ratio: "3:2",
    image_file: "japanese-tea-house-interior.jpg"
  },
  {
    category_slug: "sci-fi-cyberpunk",
    slug: "cyberpunk-market",
    title: "Midnight Street Market Neo-Shinjuku",
    body: "Crowded cyberpunk street market at night, towering holographic food advertisements in kanji, dense steam rising from noodle carts, puddles reflecting neon signs, sleek flying spinner vehicles navigating between skyscrapers overhead, cinematic anamorphic lens flare.",
    negative_prompt: "daylight, clean empty streets, cartoon characters, blurry textures, flat 2d artwork",
    ai_model: "Midjourney v6.1",
    aspect_ratio: "16:9",
    image_file: "cyberpunk-market.jpg"
  },
  {
    category_slug: "sci-fi-cyberpunk",
    slug: "mars-colony-sunrise",
    title: "Mars Research Outpost Sunrise",
    body: "Hard sci-fi research habitat on Mars at dawn, geodesic pressurized glass domes glowing with warm interior lights, heavy exploration rovers traversing red dusty basalt terrain, two astronauts in detailed EVA suits silhouetted against a pale butterscotch sunrise, concept art.",
    negative_prompt: "fantasy magic, aliens, green vegetation, low detail rover, flat cartoon, blurry background",
    ai_model: "Flux.1 Pro",
    aspect_ratio: "16:9",
    image_file: "mars-colony-sunrise.jpg"
  },
  {
    category_slug: "commercial-product",
    slug: "luxury-perfume-shot",
    title: "Obsidian Fragrance Splash Hero Shot",
    body: "Commercial hero shot of an elegant fluted glass perfume bottle with obsidian cap resting on a polished black marble slab, dynamic suspended splashes of crystal-clear water frozen mid-air, dramatic dual rim lighting, dark moody studio gradient, hyperrealistic 8k render.",
    negative_prompt: "fingerprints, dust, cheap plastic bottle, washed out lighting, blurry glass refraction, amateur product shot",
    ai_model: "Flux.1 Pro",
    aspect_ratio: "4:5",
    image_file: "luxury-perfume-shot.jpg"
  },
  {
    category_slug: "commercial-product",
    slug: "sneaker-levitation",
    title: "Minimalist Sneaker Zero-Gravity",
    body: "Minimalist pure white sneaker floating in zero-gravity over a clean pastel blush pink backdrop, soft floating silk ribbons weaving around the shoe, subtle softbox shadows, clean editorial e-commerce layout, crisp Octane 3D render.",
    negative_prompt: "dirty shoes, scuffs, busy background, harsh shadows, dark lighting, low poly model",
    ai_model: "Midjourney v6.1",
    aspect_ratio: "1:1",
    image_file: "sneaker-levitation.jpg"
  },
  {
    category_slug: "food-drink",
    slug: "rustic-sourdough",
    title: "Artisanal Crusty Sourdough Boule",
    body: "Freshly baked artisan sourdough boule with deep ear score on a flour-dusted dark oak baker's peel, delicate steam rising from the cracked golden-brown crust, rough linen kitchen towel, soft warm morning window light, shallow depth of field, food photography.",
    negative_prompt: "burnt bread, sliced white toast, grocery store plastic packaging, harsh artificial overhead lights, messy kitchen",
    ai_model: "DALL-E 3",
    aspect_ratio: "4:5",
    image_file: "rustic-sourdough.jpg"
  },
  {
    category_slug: "food-drink",
    slug: "ramen-close-up",
    title: "Steaming Tonkotsu Chashu Ramen",
    body: "Close-up macro food shot of a steaming bowl of rich tonkotsu ramen, ajitsuke tamago soft-boiled egg with jammy yolk, seared pork chashu slices, toasted nori sheet, finely chopped scallions and black garlic oil swirl, wooden chopsticks lifting noodles, appetizing editorial shot.",
    negative_prompt: "cold soup, unappetizing textures, plastic food model, dirty table, blurry bowl",
    ai_model: "Midjourney v6.1",
    aspect_ratio: "1:1",
    image_file: "ramen-close-up.jpg"
  },
  {
    category_slug: "abstract-textures",
    slug: "liquid-chrome-waves",
    title: "Iridescent Liquid Chrome Waves",
    body: "Abstract flowing ribbons of liquid chrome and molten mercury rippling in gentle curves, subtle iridescent prism sheen reflecting emerald teal and violet hues, clean studio lighting with soft specular highlights, ultra smooth fluid simulation, minimalist wallpaper.",
    negative_prompt: "noisy textures, pixelated reflections, harsh clashing colors, jagged edges, text, logos",
    ai_model: "Flux.1 Pro",
    aspect_ratio: "16:9",
    image_file: "liquid-chrome-waves.jpg"
  }
]

images_dir = Rails.root.join("db/seeds/images")

premium_slugs = %w[neon-noir-portrait brutalist-sanctuary cyberpunk-market mars-colony-sunrise luxury-perfume-shot liquid-chrome-waves]

prompts_data.each do |p_attrs|
  category = categories[p_attrs[:category_slug]]
  prompt = Prompt.find_or_initialize_by(slug: p_attrs[:slug])
  prompt.assign_attributes(
    title: p_attrs[:title],
    body: p_attrs[:body],
    negative_prompt: p_attrs[:negative_prompt],
    ai_model: p_attrs[:ai_model],
    aspect_ratio: p_attrs[:aspect_ratio],
    category: category,
    premium: premium_slugs.include?(p_attrs[:slug])
  )
  prompt.save!

  image_filename = p_attrs[:image_file]
  image_path = images_dir.join(image_filename)
  if File.exist?(image_path) && !prompt.image.attached?
    prompt.image.attach(
      io: File.open(image_path),
      filename: image_filename,
      content_type: "image/jpeg"
    )
    puts "  ↳ Attached image #{image_filename} to '#{prompt.title}'"
  end
end

puts "✓ Prompts seeded: #{Prompt.count}"

# 3. Demo User & Initial Bookmarks
demo_user = User.find_or_create_by!(email_address: "demo@promptify.test") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end

# Bookmark a few favorite prompts for demo user
favorite_slugs = %w[golden-hour-portrait brutalist-sanctuary cyberpunk-market ramen-close-up]
favorite_slugs.each do |slug|
  if (p = Prompt.find_by(slug: slug))
    Bookmark.find_or_create_by!(user: demo_user, prompt: p)
  end
end

puts "✓ Demo user seeded: #{demo_user.email_address} (password: password123)"
puts "✓ Bookmarks for demo user: #{demo_user.bookmarks.count}"

member_user = User.find_or_create_by!(email_address: "member@promptify.test") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.member_since = Time.current
end

puts "✓ Member user seeded: #{member_user.email_address} (password: password123)"
puts "== Done seeding! =="
