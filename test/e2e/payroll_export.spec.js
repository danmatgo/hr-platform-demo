const { test, expect } = require('@playwright/test');

test.describe('Payroll CSV Export', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/users/sign_in');
    await page.getByLabel('Email').fill('admin@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByRole('button', { name: 'Sign out' })).toBeVisible();
  });

  test('should export payroll CSV with employee data', async ({ page }) => {
    // Create an employee first
    await page.goto('/employees/new');
    await page.getByLabel('First name').fill('Alice');
    await page.getByLabel('Last name').fill('Williams');
    await page.getByLabel('Email').fill('alice.williams@company.com');
    await page.getByLabel('Phone').fill('555-7777');
    await page.getByLabel('Hire date').fill('2024-01-10');
    await page.getByLabel('Salary').fill('90000');
    await page.getByLabel('Position').fill('Director');
    await page.getByLabel('Department').fill('Management');
    await page.getByRole('button', { name: 'Create Employee' }).click();
    
    // Record time entry for the employee
    await page.goto('/time_entries/new');
    await page.getByLabel('Employee').selectOption({ label: 'Alice Williams' });
    await page.getByLabel('Work date').fill('2024-02-15');
    await page.getByLabel('Hours worked').fill('40');
    await page.getByLabel('Overtime hours').fill('5');
    await page.getByLabel('Notes').fill('Monthly work hours');
    await page.getByRole('button', { name: 'Create Time entry' }).click();
    
    // Navigate to payroll runs page
    await page.goto('/payroll_runs');
    await expect(page).toHaveURL('/payroll_runs');
    await expect(page.getByText('Generate payroll')).toBeVisible();
    
    // Set date range and generate payroll
    await page.fill('input[name="start_date"]', '2024-02-01');
    await page.fill('input[name="end_date"]', '2024-02-29');
    
    // Click generate payroll and wait for download to start
    const [download] = await Promise.all([
      page.waitForEvent('download', { timeout: 30000 }),
      page.click('input[value="Generate Payroll"]')
    ]);
    
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
