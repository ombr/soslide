require 'spec_helper'

describe Site do
  it { should allow_value('luc@boissaye.fr', 'contact@soslide.com').for(:email) }
  it { should_not allow_value('luc@boissaye.f', 'contact@soslide').for(:email) }
  it { should allow_value('studiocuicui', 'ombr', 'super-site53').for(:name) }
  it { should_not allow_value('12studiocuicui', '12', 'sup').for(:name) }
end
