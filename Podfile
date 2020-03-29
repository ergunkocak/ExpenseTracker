platform :ios, '12.0'
use_modular_headers!
use_frameworks!
#inhibit_all_warnings!

def common_pods
  pod 'RxSwift', '5.1.1'
  pod 'SnapKit', '5.0.0'
end

target 'ExpenseTracker' do

  common_pods

  target 'ExpenseTrackerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ExpenseTrackerUITests' do
    # Pods for testing
  end

end
