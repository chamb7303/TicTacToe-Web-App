require 'rails_helper'

describe User do
  describe ".find_or_instantiate" do
    let(:id) { 'mike' }
    let(:selector) { { _id: id } }

    subject { User.find_or_instantiate(selector) }

    context "when user exists" do
      let(:existing_user) { FactoryGirl.build(:user, _id: id) }

      before { existing_user.save }

      it "returns existing user" do
        expect(subject.id).to eq(id)
        expect(subject.persisted?).to eq(true)
      end

      it "does not call for new user" do
        expect(User).to receive(:new).never
        subject
      end
    end

    context "when user does not exist" do
      it "instantiates new user" do
        expect(subject.id).to eq(id)
        expect(subject.persisted?).to eq(false)
      end
    end
  end
end
