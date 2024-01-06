# frozen_string_literal: true

require 'spec_helper'

describe History::Audit do
  let(:audit) { History::Audit.new }
  let(:change) do
    History::ChangeSet.new(
      attribute: 'login',
      old_value: 'wimpywimpy',
      new_value: 'wimpy'
    )
  end

  let(:valid_audit) do
    History::Audit.new(
      uuid: 'fakeuuid',
      action: 'fake_action',
      user_type: 'twitch_user',
      user_id: '12345',
      resource_type: 'twitch_user',
      resource_id: '12345',
      description: 'blah blah',
      created_at: '2016-12-27 16:17:00',
      expiry: '60',
      changes: [change]
    )
  end

  describe '#set_uuid!' do
    context 'a valid audit record' do
      it 'sets the uuid correctly' do
        valid_audit.set_uuid!
        expect(valid_audit[:uuid]).to eq('c438f8fa-ad7b-5249-8ae3-7cd4085240bd')
      end
    end
  end

  describe '#to_json' do
    context 'a valid audit record' do
      let(:expected_json) { '{"uuid":"fakeuuid","action":"fake_action","user_type":"twitch_user","user_id":"12345","resource_type":"twitch_user","resource_id":"12345","description":"blah blah","created_at":"2016-12-27 16:17:00","expiry":"60","changes":[{"attribute":"login","old_value":"wimpywimpy","new_value":"wimpy"}]}' }

      subject { valid_audit.to_json }

      it 'matches the expected output' do
        expect(subject).to eql(expected_json)
      end
    end

    context 'an audit with nil changes' do
      let(:expected_json) { '{"uuid":"fakeuuid","action":"fake_action","user_type":"twitch_user","user_id":"12345","resource_type":"twitch_user","resource_id":"12345","description":"blah blah","created_at":"2016-12-27 16:17:00","expiry":"60","changes":null}' }
      let(:modified_audit) { valid_audit }

      before do
        modified_audit[:changes] = nil
      end

      subject { modified_audit.to_json }

      it 'matches the expected output' do
        expect(subject).to eql(expected_json)
      end
    end
  end

  describe '#valid?' do
    shared_examples_for 'it is invalid' do
      it 'returns false' do
        expect(subject).to be == false
      end
    end

    shared_examples_for 'it is valid' do
      it 'returns true' do
        expect(subject).to be == true
      end
    end

    context 'a valid audit record' do
      subject { valid_audit.valid? }

      it_behaves_like 'it is valid'
    end

    context 'an invalid audit record' do
      let(:audit) { valid_audit }

      subject { audit.valid? }

      context 'with a missing uuid' do
        before do
          audit[:uuid] = nil
        end

        it_behaves_like 'it is invalid'
      end

      context 'with a missing action' do
        before do
          audit[:action] = nil
        end

        it_behaves_like 'it is invalid'
      end

      context 'with a missing user type' do
        before do
          audit[:user_type] = nil
        end

        it_behaves_like 'it is invalid'
      end

      context 'with a missing user id' do
        before do
          audit[:user_id] = nil
        end

        it_behaves_like 'it is invalid'
      end

      context 'with a change set missing the attribute name' do
        before do
          audit[:changes] = [History::ChangeSet.new]
        end

        it_behaves_like 'it is invalid'
      end

      context 'with multiple missing fields' do
        before do
          audit[:uuid] = nil
          audit[:user_id] = nil
        end

        it_behaves_like 'it is invalid'
      end
    end
  end
end
