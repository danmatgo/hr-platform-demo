require "test_helper"

class BenefitPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @benefit_plan = benefit_plans(:one)
  end

  test "should get index" do
    get benefit_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_benefit_plan_url
    assert_response :success
  end

  test "should create benefit_plan" do
    assert_difference("BenefitPlan.count") do
      post benefit_plans_url, params: { benefit_plan: { cost: @benefit_plan.cost, coverage_type: @benefit_plan.coverage_type, description: @benefit_plan.description, name: @benefit_plan.name } }
    end

    assert_redirected_to benefit_plan_url(BenefitPlan.last)
  end

  test "should show benefit_plan" do
    get benefit_plan_url(@benefit_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_benefit_plan_url(@benefit_plan)
    assert_response :success
  end

  test "should update benefit_plan" do
    patch benefit_plan_url(@benefit_plan), params: { benefit_plan: { cost: @benefit_plan.cost, coverage_type: @benefit_plan.coverage_type, description: @benefit_plan.description, name: @benefit_plan.name } }
    assert_redirected_to benefit_plan_url(@benefit_plan)
  end

  test "should destroy benefit_plan" do
    assert_difference("BenefitPlan.count", -1) do
      delete benefit_plan_url(@benefit_plan)
    end

    assert_redirected_to benefit_plans_url
  end
end
