/*
 * Z2UI5_CL_SMP_APP_024 calls Z2UI5_CL_SMP_APP_025 in four ways, and 025 is
 * never started on its own (e2e/expected.mjs). Per way: the call lands in 025,
 * read pulls the caller's data through get_app_prev( ), the two views switch,
 * and back returns to 024 with the event 025 hands over.
 */
const CALLS = ['call new app (first View)', 'call new app (second View)', 'call new app (set Event)', 'call new app (set data)'];

export default async (page, { press, expectText, closePopups }) => {
  for (const call of CALLS) {
    await press(call);
    await expectText('The second app in the app-to-app flow', `"${call}" landed in Z2UI5_CL_SMP_APP_025`);
    await closePopups();
    if (call.includes('second View')) {
      await expectText('View: SECOND', '"second View" opened 025 on its second view');
      await press('show view main');
    }
    await expectText('View: FIRST');
    await press('read');
    await closePopups();
    await press('show view second');
    await expectText('View: SECOND');
    await press('show view main');
    await press('back');
    await expectText('Input made in the previous app', '024 received the event 025 left with');
    await closePopups();
    await expectText('App-to-app navigation: calls a second app', `back from "${call}" landed in 024`);
  }
};
