# frozen_string_literal: true

require 'spec_helper'

describe History::Client do
  let(:endpoint) { 'http://example.org' }

  let(:client) { History::Client.new('endpoint' => endpoint) }

  describe '#new' do
    subject { client }

    context 'with valid arguments' do
      it 'sets the expected configuration values' do
        expect(subject.endpoint).to eql(endpoint)
      end
    end

    context 'with a custom connection' do
      let(:connection) { double('connection') }
      let(:client) { History::Client.new('endpoint' => endpoint, 'connection' => connection) }

      it 'sets the connection value' do
        expect(subject.connection).to eql(connection)
      end
    end
  end

  describe '#add' do
    let(:change) do
      History::ChangeSet.new(
        attribute: 'login',
        old_value: 'wimpywimpy',
        new_value: 'wimpy'
      )
    end

    let(:audit) do
      History::Audit.new(
        uuid: 'fakeuuid',
        action: 'fake_action',
        user_type: 'twitch_user',
        user_id: '12345',
        resource_type: 'twitch_user',
        resource_id: '12345',
        description: '',
        created_at: '2016-2-27T16:17:00:2Z',
        expired_at: 60,
        changes: [change]
      )
    end

    subject { client.add(audit) }

    context 'with valid arguments' do
      let(:dummy_response) { FakeSuccessResponse.new }
      let(:faraday_dummy) { FakeFaraday.new(dummy_response) }

      before do
        expect(Faraday).to receive(:new).and_return(faraday_dummy)
      end

      it 'makes the expected call to the AWS API Gateway client' do
        expect(subject).to eql(dummy_response)
      end
    end

    context 'with invalid arguments' do
      context 'with a nil audit' do
        let(:audit) { nil }

        it 'throws an error' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'with an invalid audit' do
        let(:audit) { History::Audit.new }

        it 'throws an error' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe '#search' do
    let(:params) do
      History::SearchParams.new(
        user_id: 'aaanwar',
        page: 1,
        per_page: 10
      )
    end

    subject { client.search(params) }

    context 'with valid parameters' do
      let(:faraday_dummy) { FakeFaraday.new(FakeSuccessResponse.new) }

      before do
        expect(Faraday).to receive(:new).and_return(faraday_dummy)
      end

      it 'returns the expected results' do
        expect(subject).to_not be_nil
      end
    end
  end
end
