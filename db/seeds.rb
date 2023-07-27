require 'faker'
require 'geokit'

def to_degrees(radians)
  radians * 180 / Math::PI
end

def generate_google_id
    rand(100000000000000000000..999999999999999999999)
end

def to_radians(degrees)
  degrees * Math::PI / 180
end

def to_degrees(radians)
  radians * 180 / Math::PI
end

def to_geography_format(latitude, longitude)
  "POINT(#{longitude} #{latitude})"
end

base_latitude = -7.0174335
base_longitude = 110.3745237

def random_location_around(base_latitude, base_longitude, radius_in_meters = 5)
  earth_radius = 6371.0

  lat_offset_meters = rand(-radius_in_meters..radius_in_meters)
  lng_offset_meters = rand(-radius_in_meters..radius_in_meters)

  lat_offset_degrees = to_degrees(lat_offset_meters / earth_radius)
  lng_offset_degrees = to_degrees(lng_offset_meters / (earth_radius * Math.cos(to_radians(base_latitude))))

  lat = base_latitude + lat_offset_degrees
  lng = base_longitude + lng_offset_degrees

  lat = [lat, 90.0].min
  lng = [lng, 180.0].min

  to_geography_format(lat, lng)
end

ROLES = ['User', 'Therapist']

50.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    google_id: generate_google_id,
    avatar: Faker::Avatar.image(size: '150x150', format: 'png', set: 'set4'),
    role: ROLES.sample
  )
end

User.all.each do |user|
    if user.role == 'Therapist'
        location = random_location_around(base_latitude, base_longitude)
        params = {
            user_id: user.id,
            location: location,
            experience_years: rand(1..10),
            day_start: rand(0..6),
            day_end: rand(0..6),
            working_start: Faker::Time.between(from: DateTime.now.beginning_of_day, to: DateTime.now.end_of_day),
            working_end: Faker::Time.between(from: DateTime.now.beginning_of_day, to: DateTime.now.end_of_day),
            birthdate: Faker::Date.birthday(min_age: 25, max_age: 65),
            gender: ['MALE', 'FEMALE'].sample,
            is_available: ['true', 'false'].sample
        }
        data = Therapist.create(params)
    end
end

service_data = [
  {
    name: "Deep Tissue Massage",
    description: "Deep Tissue Massage adalah terapi pijat yang menargetkan kelompok otot dan jaringan ikat yang lebih dalam. Tujuannya adalah meredakan nyeri dan ketegangan otot kronis, meningkatkan rentang gerak, dan memperbaiki postur. Terapis menggunakan tekanan kuat untuk menjangkau lapisan yang lebih dalam dari otot dan jaringan ikat. Sesinya biasanya berlangsung antara 60 hingga 90 menit",
    minimum_duration: 1,
    price_per_hour: 500000
  },
  {
    name: "Swedish Massage",
    description: "Swedish Massage adalah jenis terapi pijat yang paling umum dan terkenal. Teknik ini menggunakan serangkaian gerakan berupa menggosok, mengknead, dan mengetuk untuk meredakan ketegangan otot, mempromosikan relaksasi, dan meningkatkan sirkulasi darah. Manfaat lainnya termasuk peningkatan fleksibilitas dan kesejahteraan emosional. Swedish Massage adalah cara yang sempurna untuk meredakan stres dan memanjakan diri Anda.",
    minimum_duration: 1,
    price_per_hour: 400000
  },
  {
    name: "Hot Stone Massage",
    description: "Hot Stone Massage adalah jenis terapi pijat yang menggunakan batu panas sebagai alat utama. Batu-batu tersebut, biasanya batu basalt yang telah dipanaskan, ditempatkan pada titik-titik tertentu di seluruh tubuh untuk membantu meredakan ketegangan otot dan meningkatkan aliran darah. Teknik ini menghasilkan sensasi hangat yang mendalam dan relaksasi yang nyaman, sehingga sangat efektif untuk membantu meredakan stres dan meningkatkan kesejahteraan secara keseluruhan.",
    minimum_duration: 1,
    price_per_hour: 700000
  },
  {
    name: "Aromatherapy Massage",
    description: "Aromatherapy Massage adalah jenis terapi pijat yang menggabungkan penggunaan minyak esensial aromatik untuk meningkatkan manfaat pijat. Minyak esensial yang diekstrak dari tumbuhan, bunga, dan rempah-rempah digunakan untuk meningkatkan suasana hati, mengurangi stres, dan mendukung perasaan kesejahteraan. Pijat aromaterapi tidak hanya melibatkan teknik pijat yang menenangkan dan mengurangi ketegangan otot, tetapi juga memberikan pengalaman multisensorial yang dapat meremajakan pikiran dan tubuh.",
    minimum_duration: 1,
    price_per_hour: 850000
  },
  {
    name: "Reflexology",
    description: "Reflexology adalah teknik pijat khusus yang menekankan pada titik-titik refleksi tertentu di tangan, kaki, dan telinga yang sesuai dengan area dan organ lainnya di dalam tubuh. Reflexology berfungsi untuk meningkatkan keseimbangan dan kesejahteraan tubuh secara keseluruhan. Ini bisa menjadi pengalaman yang sangat menenangkan dan relaksasi, sekaligus berfungsi untuk membantu tubuh meredakan stres dan ketegangan.",
    minimum_duration: 1,
    price_per_hour: 100000
  },
  {
    name: "Facial Treatments",
    description: "Ini melibatkan berbagai perawatan wajah, seperti pembersihan, pengeksfoliasian, pemijatan, dan perawatan lainnya",
    minimum_duration: 1,
    price_per_hour: 120000
  },
  {
    name: "Body Scrubs and Wraps",
    description: "Perawatan wajah atau Facial Treatments adalah rangkaian perawatan yang dirancang untuk memperbaiki dan merawat kulit wajah. Perawatan ini mungkin mencakup pembersihan mendalam, eksfoliasi, ekstraksi komedo, pengaplikasian masker, serum, pelembab, dan perlindungan sinar matahari. Perawatan wajah juga seringkali menyertakan pijatan ringan pada wajah dan leher untuk meningkatkan sirkulasi dan kekenyalan kulit.",
    minimum_duration: 1,
    price_per_hour: 100000
  }
]

service_data.each do |service|
  Service.create(service)
end

Therapist.all.each do |therapist|
  countService = Service.all.count
  count = rand(1..countService.to_i)
  Service.all.each do |servic|
    TherapistService.create({
      therapist_id: therapist.id,
      service_id: servic.id
    })
  end
end

therapist = TherapistService.all.pluck(:therapist_id)
payment = ['waiting_payment', 'appoinment_start', 'done', 'paid']
User.where(role: 'User').each do |user|
  therapist_sample = therapist.sample
  next if TherapistService.where(therapist_id: therapist_sample).nil?
  service = TherapistService.where(therapist_id: therapist_sample).pluck(:service_id)
  service_id = service.sample
  service = Service.find_by(id: service_id)
  duration = rand(10..50)

  order = Order.create({
    user_id: user.id,
    therapist_id: therapist_sample,
    service_id: service_id,
    order_status: ['waiting_confirmation', 'waiting_payment', 'paid', 'appoinment_at', 'done', 'canceled', 'expired'].sample,
    appointment_duration: duration,
    appointment_date: Faker::Time.between(from: 2.years.ago, to: Time.now),
    total_price: (duration / 60) * service.price_per_hour,
    location: random_location_around(base_latitude, base_longitude),
    note: Faker::Lorem.sentence
  })

  if payment.include?(order.order_status)
    payment = ['pending', 'success', 'expired'].sample
    payment_expired = order.created_at.to_i + 3600
    payment_at = payment == 'success' ? order.created_at.to_i + 2500 : nil
    payment_build = Payment.create({
      order_id: order.id,
      user_id: order.user_id,
      payment_method: ['ovo', 'dana', 'bidr'].sample,
      payment_status: payment,
      amount_paid: order.total_price,
      to_account: order.therapist.user.email,
      sender_account: order.user.email,
      payment_expired: payment_expired,
      payment_at: payment_at
    })
  end

  if order.order_status == 'done'
    Rating.create({
      user_id: order.user_id,
      therapist_id: order.therapist_id,
      order_id: order.id,
      rating: rand(1..5)
    })
  end

    5.times do
      ActivityHistory.create({
        user_id: order.user_id,
        activity_type: ['Login', 'Make an Appointment', 'Submit Review', 'Cancel Order'].sample,
        location: random_location_around(base_latitude, base_longitude),
        ip_address: Faker::Internet.ip_v4_address,
        device_info: Faker::Internet.user_agent,
        result: ['success', 'failed'].sample
      })
  end

  Notification.create({
    user_id: order.user_id,
    messages: Faker::Lorem.sentence,
    is_send: ['true', 'false'].sample,
    is_read: ['true', 'false'].sample,
    reference_id: order.id,
    reference_type: 'Order'
  })
end

Therapist.all.each do |therapist|
  balance = Balance.create({
    therapist_id: therapist.id,
    balance_amount: rand(10000..99999)
  })
end