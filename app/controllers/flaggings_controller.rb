class FlaggingsController < ApplicationController
  def create
    get_flaggable
    @flagging = current_user.flaggings.build(get_flaggable_params)
    if @flagging.save
      flash[:notice] = "saved"
    else
      flash[:alert] = "failed"
    end
  end

  def edit
    #code
  end

  def update
    #code
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
      @flaggable = Word.find(params[:word_id])
    elsif params[:definition_id]
      @flaggable = Definition.find(params[:definition_id])
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
