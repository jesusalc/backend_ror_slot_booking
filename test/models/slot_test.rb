require 'test_helper'

class SlotTest < ActiveSupport::TestCase
  test 'should not save slot without start and end' do
    slot = Slot.new
    assert_not slot.save, 'Saved the slot without start and end'
  end

  test 'end should be after start' do
    slot = Slot.new(start: Time.now, end: Time.now - 1.hour)
    assert_not slot.save, 'Saved the slot with end before start'
  end
end
