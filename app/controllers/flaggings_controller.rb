class FlaggingsController < ApplicationController

  def new
    @flaggable = get_flaggable
    @flagging = Flagging.new
  end

  def create
    @flagging = current_user.flaggings.build(get_flaggable_params)
    @flaggable = get_flaggable
    if @flagging.save
      flash[:notice] = "saved"
    else
      flash[:alert] = "failed"
    end
    redirect_to @flaggable
  end

  def destroy
    #code
  end

private

  # def flagging_params
  #   params.require(:flagging).permit(
  #     # :flaggable,
  #     :flaggable_id,
  #     :flaggable_type,
  #     :flagger_id,
  #     :flagger_type,
  #     :reason,
  #     :comment
  #   )
  # end

  def get_flaggable
    if params[:word_id]
      Word.find(params[:word_id])
    elsif params[:definition_id]
      Definition.find(params[:definition_id])
    end
  end

  def get_flaggable_params
    {
      flaggable_id: @flaggable.id,
      flaggable_type: @flaggable.class,
      flagger_id: current_user.id,
      flagger_type: current_user.class
    }
  end

end
