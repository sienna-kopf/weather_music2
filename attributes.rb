
max = 134.0
min = 0.0
val = forecast.temp.to_f

math = [0, [1, (val - min) / (max - min)].min].max

# compare against valence of a track
# sort_by (valence - math).abs

valence_hash = songs[:audio_features].sort_by do |song|
  (song[:valence] - math).abs
end.take(20)

song_ids = valence_hash.map do |song|
  song[:id]
end
