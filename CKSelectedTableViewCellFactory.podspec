Pod::Spec.new do |s|
  s.name         =  'CKSelectedTableViewCellFactory'
  s.version      =  '0.0.3'
  s.platform 	   =  :ios
  s.license      =  {:type => 'BSD'}
  s.homepage     =  'https://github.com/codykimberling/CKSelectedTableViewCellFactory/'
  s.authors      =  {'Cody Kimberling' => 'clkimberling@gmail.com'}
  s.summary      =  'Selected Background factory UITableViewCell.'
  s.description  =  'Selected Background factory UITableViewCell.  Works with Plain and Grouped TableViews and allows for custom corner radius and backgroundColor.'
  s.source       =  {:git => 'https://github.com/codykimberling/CKSelectedTableViewCellFactory.git', :tag => '0.0.3'}
  s.source_files =  'CKSelectedTableViewCellFactory.{h,m}'
  s.requires_arc = 	true
end
