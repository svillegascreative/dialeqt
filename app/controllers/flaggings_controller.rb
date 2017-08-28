class FlaggingsController < ApplicationController

  def new
    @flaggable = get_flaggable
    @flagging = Flagging.new
  end

  def create
    @flaggable = get_flaggable
    @flagging = current_user.flaggings.build(all_params)
    if @flagging.save
      flash[:notice] = "Thank you for calling this #{@flagging.reason} #{@flaggable.class.to_s.downcase} to our attention."
    else
      flash[:alert] = "The flag could not be saved. Please try again."
    end
      redirect_to root_url
  end

  def destroy
    #code
  end

private

  def flagging_params
    params.require(:flagging).permit(
      :flaggable_id,
      :flaggable_type,
      :flagger_id,
      :flagger_type,
      :reason,
      :comment
    )
  end

  def get_flaggable
    if params[:word_id]
      Word.find(params[:word_id])
    elsif params[:definition_id]
      Definition.find(params[:definition_id])
    end
  end

  def flaggable_params
    {
      flaggable_id: @flaggable.id,
      flaggable_type: @flaggable.class
    }
  end

  def all_params
    flagging_params.merge(flaggable_params)
  end

end
