insert into public.containers (lat, lng, address, status, fill_level, accepted_types, last_emptied)
values
  (41.311151, 69.279737, 'Amir Temur Avenue 12, Tashkent', 'active', 23, array['plastic','paper','glass']::public.waste_type[], now() - interval '2 days'),
  (41.305129, 69.281821, 'Yunusobod 4-block, Tashkent', 'active', 67, array['plastic','metal']::public.waste_type[], now() - interval '5 days'),
  (41.299496, 69.240073, 'Chilonzor 9, Tashkent', 'maintenance', 84, array['organic','paper']::public.waste_type[], now() - interval '8 days'),
  (41.329450, 69.228580, 'Sebzor Street 6, Tashkent', 'active', 45, array['glass','metal']::public.waste_type[], now() - interval '1 day'),
  (41.318112, 69.295603, 'Buyuk Ipak Yuli 88, Tashkent', 'active', 31, array['plastic','paper','organic']::public.waste_type[], now() - interval '3 days'),
  (41.287441, 69.203093, 'Qatortol 17, Tashkent', 'offline', 92, array['plastic']::public.waste_type[], now() - interval '10 days'),
  (41.336200, 69.334090, 'Mirzo Ulugbek 52, Tashkent', 'active', 12, array['paper','glass']::public.waste_type[], now() - interval '12 hours'),
  (41.266775, 69.216116, 'Olmazor Street 3, Tashkent', 'active', 59, array['organic','metal']::public.waste_type[], now() - interval '4 days'),
  (41.301892, 69.326891, 'Parkent Bazar, Tashkent', 'active', 48, array['plastic','paper','glass','metal']::public.waste_type[], now() - interval '2 days'),
  (41.275590, 69.283040, 'Bunyodkor Avenue 26, Tashkent', 'maintenance', 81, array['organic','paper']::public.waste_type[], now() - interval '6 days'),
  (41.340345, 69.277700, 'Bodomzor Metro Exit A, Tashkent', 'active', 36, array['plastic','metal','glass']::public.waste_type[], now() - interval '1 day'),
  (41.289200, 69.247810, 'Navoi Street 14, Tashkent', 'active', 28, array['paper','organic']::public.waste_type[], now() - interval '2 days'),
  (41.307892, 69.355031, 'TTZ-2, Tashkent', 'active', 61, array['plastic','paper']::public.waste_type[], now() - interval '5 days'),
  (41.320140, 69.210420, 'Karakamish 1/4, Tashkent', 'active', 40, array['glass','metal','organic']::public.waste_type[], now() - interval '3 days'),
  (41.315770, 69.347120, 'Salar Canal Road, Tashkent', 'offline', 96, array['plastic','glass']::public.waste_type[], now() - interval '11 days'),
  (41.286510, 69.312450, 'Yakkasaroy 6, Tashkent', 'active', 52, array['paper','metal']::public.waste_type[], now() - interval '4 days'),
  (41.323620, 69.252340, 'Tinchlik Square, Tashkent', 'active', 27, array['plastic','organic']::public.waste_type[], now() - interval '20 hours'),
  (41.272430, 69.265980, 'Muqimiy Theatre stop, Tashkent', 'maintenance', 74, array['paper','glass','organic']::public.waste_type[], now() - interval '7 days'),
  (41.333980, 69.301240, 'Minor Mosque area, Tashkent', 'active', 33, array['plastic','paper','metal']::public.waste_type[], now() - interval '2 days'),
  (41.296050, 69.356480, 'Mashinasozlar metro, Tashkent', 'active', 49, array['glass','organic']::public.waste_type[], now() - interval '36 hours');

insert into public.events (title, description, location, event_date, bonus_coins, max_participants, status)
values
  (
    'Eco Saturday Cleanup',
    'Neighborhood cleanup event focused on recyclable waste collection and sorting.',
    'Eco Park, Tashkent',
    now() + interval '10 days',
    200,
    150,
    'upcoming'
  ),
  (
    'Paper Recycling Workshop',
    'Learn practical techniques to recycle and repurpose paper waste at home and school.',
    'Yunusobod Youth Center',
    now() + interval '17 days',
    120,
    80,
    'upcoming'
  );
