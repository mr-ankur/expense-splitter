class ExpensesController < ApplicationController
  before_action :load_user, only: :create
  before_action :load_expense, only: :destroy

  def create
    expense = @user.expenses.new(expense_params)
    user_ids = filtered_user_ids
    if expense.save && user_ids.count.nonzero?
      split_amount = expense.calculate_split_amount(user_ids)
      split_remainder_amount = expense.calculate_split_remainder_amount(split_amount)
      user_ids.each_with_index do |u_id, index|
        amount = index.eql?(1) && split_amount.nonzero?  ? split_amount + split_remainder_amount : split_amount
        expense.splits.create(user_id: u_id, amount: amount)
      end
      flash[:notice] = "Expense Saved Successfully"
    else
      error_messages = expense.errors.full_messages
      error_messages << "Friends can't be blank" if user_ids.count.zero?
      flash[:alert] = error_messages
    end
    redirect_to root_path
  end

  def destroy
    if @expense&.destroy.present?
      flash[:notice] = "Expense Deleted Successfully"
      redirect_to "/people/#{@expense.incurred_by_id}"
    else
      flash[:alert] = "Something went wrong"
      redirect_to root_path
    end
  end

  private

  def load_user
    @user = current_user
  end

  def filtered_user_ids
    expense_params[:user_ids].select {|x| x.present?}
  end

  def load_expense
    @expense = Expense.find_by_id(params[:id])
  end

  def expense_params = params.require(:expense).permit(:incurred_at, :incurred_by_id, :paid_by_id, :total_amount, :description, user_ids: [])
end
