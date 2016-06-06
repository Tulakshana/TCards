
Pod::Spec.new do |s|
  s.name                          = 'TCards'
  s.version                       = '0.1.0'
  s.summary                       = 'A simple stacked card view inspired by UPCardsCarousel'
  s.description                   = 'A simple stacked card view inspired by UPCardsCarousel. Navigation is made possible both prgrammatically and through swipe gestures'
  s.homepage                      = 'https://github.com/Tulakshana/TCards'
  s.screenshots                   = 'https://raw.githubusercontent.com/Tulakshana/TCards/master/TCards/demo.gif'
  s.license                       = { :type => 'MIT', :file => 'LICENSE' }
  s.author                        = { 'Tulakshana' => 'tula_post@yahoo.com' }
  s.source                        = { :git => 'https://github.com/Tulakshana/TCards.git', :tag => s.version.to_s }
  s.ios.deployment_target         = '8.0'
  s.source_files                  = 'TCards/Classes/**/*'
end
