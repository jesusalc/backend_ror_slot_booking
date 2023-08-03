# frozen_string_literal: true

# This file should contain all the record creation needed to seed the
# database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside
# the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
slots = [
  { "start": '2022-02-01T20:00:00.000Z', "end": '2022-02-01T22:30:00.000Z' },
  { "start": '2022-01-31T23:00:00.000Z', "end": '2022-02-01T06:00:00.000Z' },
  { "start": '2022-02-01T10:15:00.000Z', "end": '2022-02-01T10:45:00.000Z' },
  { "start": '2022-02-01T13:55:00.000Z', "end": '2022-02-01T14:30:00.000Z' },
  { "start": '2022-02-02T10:00:00.000Z', "end": '2022-02-02T20:00:00.000Z' },
  { "start": '2022-02-01T09:00:00.000Z', "end": '2022-02-01T10:00:00.000Z' },
  { "start": '2022-02-01T11:30:00.000Z', "end": '2022-02-01T13:00:00.000Z' },
  { "start": '2022-02-01T13:00:00.000Z', "end": '2022-02-01T13:10:00.000Z' },
  { "start": '2023-08-01T20:00:00.000Z', "end": '2023-08-01T22:30:00.000Z' },
  { "start": '2023-07-31T23:00:00.000Z', "end": '2023-08-01T06:00:00.000Z' },
  { "start": '2023-08-01T10:15:00.000Z', "end": '2023-08-01T10:45:00.000Z' },
  { "start": '2023-08-01T13:55:00.000Z', "end": '2023-08-01T14:30:00.000Z' },
  { "start": '2023-08-02T10:00:00.000Z', "end": '2023-08-02T20:00:00.000Z' },
  { "start": '2023-08-01T09:00:00.000Z', "end": '2023-08-01T10:00:00.000Z' },
  { "start": '2023-08-01T11:30:00.000Z', "end": '2023-08-01T13:00:00.000Z' },
  { "start": '2023-08-01T13:00:00.000Z', "end": '2023-08-01T13:10:00.000Z' }
]

puts 'Hardcoded booked slots'
puts '... go get your coffee this takes about 15 minutes in an intel i5'
puts '... not so fast there'
puts '.... but takes about 2-4 minutes in an M2 mac arm 64'
slots.each do |slot|
  Slot.create!(slot)
end

# opens = [
#  { "id": "....", "start": "2022-02-01T20:00:00.000Z", "end": "2022-02-01T22:30:00.000Z" },
# ]
# Assuming 'opens' is an empty array to start with
opens = []

# Define the start and end date ranges (from now to 2 years)
start_date = DateTime.now
target_date = DateTime.now + 2.years

puts 'Generating open slots for next two years'
# Loop through the date range with 15-minute intervals
while start_date <= target_date
  # Round the minutes to 00
  start_date = start_date.change(min: (start_date.min / 15) * 15, sec: 0)

  # Calculate the end time (15 minutes after the start time)
  end_date = start_date + 15.minutes

  # Add the slot to the 'opens' array as a hash
  opens << { start: start_date, end: end_date }

  # Move to the next 15-minute interval
  start_date += 15.minutes
end

puts 'Saving open slots'
# Now, 'opens' contains the open slots with 15-minute intervals from now to the next two years.
# You can create the records in the database using the following loop:
opens.each do |open|
  Open.create!(open)
end

puts 'Generating booked slots for next two years randomly'
slots = []

# Define the start and end date ranges (from now to 2 years)
start_date = DateTime.now

# Loop through the date range
while start_date <= target_date
  # Generate 10 random 15-minute slots for the current day
  10.times do
    # Get a random hour and minute
    random_hour = rand(0..23)
    random_minute = rand(0..3) * 15 # Multiples of 15 to align with 15-minute intervals

    # Set the start time for the slot
    start_time = start_date.change(hour: random_hour, min: random_minute, sec: 0)

    # Calculate the end time (15 minutes after the start time)
    end_time = start_time + 15.minutes

    # Add the slot to the 'slots' array as a hash
    slots << { start: start_time, end: end_time }
  end

  # Move to the next day
  start_date += 1.day
end

puts 'Saving booked slots'
# Now, 'slots' contains 10 random 15-minute slots per day from now to the next two years.
# You can create the records in the database using the following loop:
slots.each do |slot|
  Slot.create!(slot)
end
