Pod::Spec.new do |s|
s.name             = "ModernSearchBar"
s.version          = "1.5"
s.summary          = "ModernSearchBar"
s.description      = "The famous iOS search bar with auto completion feature implemented."
s.homepage         = "https://github.com/PhilippeBoisney/ModernSearchBar"
s.license          = 'APACHE'
s.author           = { "PhilippeBoisney" => "phil.boisney@gmail.com" }
s.source           = { :git => "https://github.com/PhilippeBoisney/ModernSearchBar.git", :tag => s.version }
s.platform     = :ios, '8.0'
s.requires_arc = true

# If more than one source file: https://guides.cocoapods.org/syntax/podspec.html#source_files
s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
  'ModernSearchBar' => [
      'Pod/Assets.xcassets'
  ]
}

end
