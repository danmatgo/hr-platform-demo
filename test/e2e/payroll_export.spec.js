const { test, expect } = require('@playwright/test');

test.describe('Payroll CSV Export', () => {
  test.beforeEach(async ({ page }) => {
    // Login first
    await page.goto('/users/sign_in');
    await page.fill('input[name="user[email]"]', 'admin@example.com');
    await page.fill('input[name="user[password]"]', 'password123');
    await page.click('input[type="submit"]');
    await expect(page).toHaveURL('/');
  });

  test('should export payroll CSV with employee data', async ({ page }) => {
    // Create an employee first
    await page.goto('/employees/new');
    await page.fill('input[name="employee[first_name]"]', 'Alice');
    await page.fill('input[name="employee[last_name]"]', 'Williams');
    await page.fill('input[name="employee[email]"]', 'alice.williams@company.com');
    await page.fill('input[name="employee[phone]"]', '555-7777');
    await page.fill('input[name="employee[hire_date]"]', '2024-01-10');
    await page.fill('input[name="employee[salary]"]', '90000');
    await page.fill('input[name="employee[position]"]', 'Director');
    await page.fill('input[name="employee[department]"]', 'Management');
    await page.click('input[type="submit"]');
    
    // Record time entry for the employee
    await page.goto('/time_entries/new');
    await page.selectOption('select[name="time_entry[employee_id]"]', { label: 'Alice Williams' });
    await page.fill('input[name="time_entry[work_date]"]', '2024-02-15');
    await page.fill('input[name="time_entry[hours_worked]"]', '40');
    await page.fill('input[name="time_entry[overtime_hours]"]', '5');
    await page.fill('textarea[name="time_entry[notes]"]', 'Monthly work hours');
    await page.click('input[type="submit"]');
    
    // Navigate to payroll runs page
    await page.goto('/payroll_runs');
    await expect(page).toHaveURL('/payroll_runs');
    await expect(page.locator('text=Generate payroll')).toBeVisible();
    
    // Set date range and generate payroll
    await page.fill('input[name="start_date"]', '2024-02-01');
    await page.fill('input[name="end_date"]', '2024-02-29');
    
    // Click generate payroll button
    await page.click('input[value="Generate Payroll"]');
    
    // Wait for the download to start
    const download = await page.waitForEvent('download');
    
    // Verify the download
    expect(download.suggestedFilename()).toMatch(/payroll_202402\.csv/);
    
    // Read the downloaded file
    const path = await download.path();
    const fs = require('fs');
    const csvContent = fs.readFileSync(path, 'utf8');
    
    // Verify CSV content contains expected headers and data
    expect(csvContent).toContain('Employee Name,Hours Worked,Overtime Hours,Gross Pay,Period Start,Period End');
    expect(csvContent).toContain('Alice Williams');
    expect(csvContent).toContain('40'); // hours worked
    expect(csvContent).toContain('5'); // overtime hours
  });
});
