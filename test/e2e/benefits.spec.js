const { test, expect } = require('@playwright/test');

test.describe('Benefits Management', () => {
  test.beforeEach(async ({ page }) => {
    // Login first
    await page.goto('/users/sign_in');
    await page.fill('input[name="user[email]"]', 'admin@example.com');
    await page.fill('input[name="user[password]"]', 'password123');
    await page.click('input[type="submit"]');
    await expect(page).toHaveURL('/');
  });

  test('should create benefit plan and enroll employee', async ({ page }) => {
    // First create a benefit plan
    await page.goto('/benefit_plans/new');
    await expect(page).toHaveURL('/benefit_plans/new');
    
    await page.fill('input[name="benefit_plan[name]"]', 'Health Insurance Premium');
    await page.fill('textarea[name="benefit_plan[description]"]', 'Comprehensive health insurance coverage for employees');
    await page.fill('input[name="benefit_plan[cost]"]', '500.00');
    await page.selectOption('select[name="benefit_plan[coverage_type]"]', 'Health');
    
    await page.click('input[type="submit"]');
    await expect(page.locator('.notice')).toContainText('Benefit plan was successfully created');
    
    // Create an employee first
    await page.goto('/employees/new');
    await page.fill('input[name="employee[first_name]"]', 'Bob');
    await page.fill('input[name="employee[last_name]"]', 'Johnson');
    await page.fill('input[name="employee[email]"]', 'bob.johnson@company.com');
    await page.fill('input[name="employee[phone]"]', '555-9999');
    await page.fill('input[name="employee[hire_date]"]', '2024-02-01');
    await page.fill('input[name="employee[salary]"]', '80000');
    await page.fill('input[name="employee[position]"]', 'Manager');
    await page.fill('input[name="employee[department]"]', 'Operations');
    await page.click('input[type="submit"]');
    
    // Now create enrollment
    await page.goto('/enrollments/new');
    await expect(page).toHaveURL('/enrollments/new');
    
    // Select employee and benefit plan
    await page.selectOption('select[name="enrollment[employee_id]"]', { label: 'Bob Johnson' });
    await page.selectOption('select[name="enrollment[benefit_plan_id]"]', { label: 'Health Insurance Premium' });
    await page.fill('input[name="enrollment[enrollment_date]"]', '2024-02-15');
    await page.selectOption('select[name="enrollment[status]"]', 'Active');
    
    await page.click('input[type="submit"]');
    await expect(page.locator('.notice')).toContainText('Enrollment was successfully created');
  });
});