
Pod::Spec.new do |s|
  s.name             = "TCards"
  s.version          = "1.0"
  s.summary          = "A simple stacked card view inspired by UPCardsCarousel"
  s.description      = ""
  s.homepage         = "https://github.com/Tulakshana/TCards"
  s.screenshots      = "https://raw.githubusercontent.com/Tulakshana/TCards/master/TCards/demo.gif"
  s.license          = 'MIT'
  s.author           = { "Tulakshana" => "tula_post@yahoo.com" }
  s.source           = { :git => "https://github.com/Tulakshana/TCards.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'TCards/Classes/'
end
