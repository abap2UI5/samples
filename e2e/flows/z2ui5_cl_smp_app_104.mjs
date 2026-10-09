/*
 * Z2UI5_CL_SMP_APP_104 embeds Z2UI5_CL_SMP_APP_105 and Z2UI5_CL_SMP_APP_112,
 * which build into the view it hands them and are never started on their own
 * (e2e/expected.mjs). Selecting a row renders the sub-app, and its event and
 * its bound input reach the sub-app, not 104.
 */
const SUBS = [['Class 1', 'SUB-APP CLASS 1', 'raise event in sub-app 1', 'event raised in SUB-APP CLASS 1'],
  ['Class 2', 'SUB-APP CLASS 2', 'raise event in sub-app 2', 'event raised in SUB-APP CLASS 2']];

export default async (page, { press, pressItem, expectText, closePopups, waitForIdle }) => {
  for (const [row, title, button, answer] of [...SUBS, SUBS[0]]) {
    await pressItem(row);
    await expectText(title, `selecting "${row}" rendered ${title}`);
    await press(button);
    await expectText(answer, `"${button}" was answered by the sub-app`);
    await closePopups();
    const input = page.locator('input[placeholder*="sub-app"]').first();
    await input.fill('e2e');
    await input.press('Enter');
    await waitForIdle();
  }
};
