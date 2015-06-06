FactoryGirl.define do
  factory :ttt_game do
    _id { '5575273462616e075700004c' }
    board_state { [nil] * 9 }
    players { FactoryGirl.build_list(:user, 2) }
  end

  factory :user do
    _id { ('a'..'z').to_a.shuffle[0..10].join }
  end
end
