# app/services/slot_creator.rb
class SlotCreator
  def self.create(params)
    slot = Slot.new(params)
    if slot.save
      { success: true, message: 'Slot booked successfully!' }
    else
      { success: false, errors: slot.errors }
    end
  end
end
