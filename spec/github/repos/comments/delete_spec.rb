# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Comments, '#delete' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:comment_id) { 1 }
  let(:request_path) { "/repos/#{user}/#{repo}/comments/#{comment_id}" }

  before {
    stub_delete(request_path).
      to_return(:body => body, :status => status,
        :headers => { :content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource deleted successfully" do
    let(:body) { '' }
    let(:status) { 204 }

    it "should fail to delete without 'user/repo' parameters" do
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "should fail to delete resource without 'comment_id'" do
      expect {
        subject.delete user, repo, nil
      }.to raise_error(ArgumentError)
    end

    it "should delete the resource" do
      subject.delete user, repo, comment_id
      a_delete(request_path).should have_been_made
    end
  end

  context "failed to delete resource" do
    let(:body) { '' }
    let(:status) { 404 }

    it "should fail to find resource" do
      expect {
        subject.delete user, repo, comment_id
      }.to raise_error(Github::Error::NotFound)
    end
  end
end # delete
