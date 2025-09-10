// this script generates and inserts simulated outbound order data into our MySQL database. 
// It inserts data into both the OUTBOUND_ORDER and OUTBOUND_ORDER_ITEM tables. 
// The data reflects realistic ordering patterns based on product types, seasonal trends, and holidays.

// To use this script, ensure you have Node.js installed.

// 1. in bash navigate to the directory where this script is located on you pc

// 2. install the mysql2 package
// type this in your terminal:
// ```
// npm install mysql2
// ```
// 3. 
// then type this in your terminal:
// ```
// node script2.js
// ```


const mysql = require('mysql2/promise');
const { randomUUID, DiffieHellmanGroup } = require('crypto');

const db = {
  host: 'itwillbs.com',
  user: 'c5d2504t1p2',
  password: '1234',
  database: 'c5d2504t1p2'
};


// These arrays of products are ordered at different frequencies
const beanTypes = [101, 113, 114, 115, 116]; // Coffee beans

const dailyItems = [
  103, 127, 128, 129, 130, 131, 132, // Cups & lids
  119, 120, 121, 122                 // Milk & syrups
];

const weeklyItems = [
  104, 117, 118,                    // Tea & matcha
  106, 107, 108, 109, 110,          // Accessories
  133, 134, 135, 136, 137           // Sleeves, straws, napkins, carriers
];

const rareItems = [
  102,                              // Sugar sticks
  123, 124, 125, 126,               // Office supplies
  138, 139, 140, 141, 142, 143      // Cleaning & safety
];

// On these holidays, order volumes are higher
function isHoliday(date) {
  const holidays = ['01-01', '03-01', '05-05', '08-15', '10-03', '12-25'];
  const md = date.toISOString().slice(5, 10);
  return holidays.includes(md);
}

// There is a little more product demand in winter and summer
function isWinter(date) {
  const month = date.getMonth() + 1;
  return [12, 1, 2].includes(month);
}

function isSummer(date) {
  const month = date.getMonth() + 1;
  return [6, 7, 8].includes(month);
}

// adjusts product demand depending on the date
function getItemCountForDate(date, highVolume) {
  let base = highVolume ? 5 : 2;
    // let base = highVolume ? 2 : 1;
  if (isHoliday(date)) base += 3;
  if (isWinter(date)) base += 2;
  if (isSummer(date)) base += 1;
  return base + Math.floor(Math.random() * 3);
}

// controls how much quantity is ordered 
function getQuantityForProduct(productIdx, highVolume, date) {
  // let baseQty = highVolume ? 10 : 3;
  let baseQty = highVolume ? 2 : 1;
  if (isHoliday(date)) baseQty += 5;
  if (isWinter(date) && productIdx === 104) baseQty += 5;
  if (isSummer(date) && productIdx === 116) baseQty += 5;
  // return baseQty + Math.floor(Math.random() * 5);
  return baseQty;
}

// this function chooses what products to order on a given date
function generateItemsForDate(date, highVolume, orderIdx, dayIndex) {
  const items = [];
  let itemIdxSeed = Math.floor(Math.random() * 1_000_000);

  const itemCount = getItemCountForDate(date, highVolume);
  for (let i = 0; i < itemCount; i++) {
    const productIdx = beanTypes[Math.floor(Math.random() * beanTypes.length)];
    const qty = getQuantityForProduct(productIdx, highVolume, date);
    items.push([orderIdx, productIdx, randomUUID().slice(0, 8), qty]);
  }

  for (const productIdx of dailyItems) {
    if (Math.random() < 0.5) {
      const qty = getQuantityForProduct(productIdx, highVolume, date);
      items.push([orderIdx, productIdx, randomUUID().slice(0, 8), qty]);
    }
  }

  // Weekly items: only deliver on Mondays
  if (date.getDay() === 1) {
    for (const productIdx of weeklyItems) {
      const qty = getQuantityForProduct(productIdx, highVolume, date);
      items.push([orderIdx, productIdx, randomUUID().slice(0, 8), qty]);
    }
  }

  // Rare items: deliver every 10th day
  if (dayIndex % 10 === 0) {
    for (const productIdx of rareItems) {
      const qty = getQuantityForProduct(productIdx, highVolume, date);
      items.push([orderIdx, productIdx, randomUUID().slice(0, 8), qty]);
    }
  }

  return items;
}

// calls the previous functions to generate and insert data into the database
async function generateData(franchiseIdx, highVolume) {
  const connection = await mysql.createConnection(db);
  const today = new Date();
  const startDate = new Date(today);

//   change the last number to set how many days of data you want
  startDate.setDate(today.getDate() - 1900);

  let dayIndex = 0;


  //for each franchise add 2000 if you want 5 years of data
  let orderIdx = 2000;

  for (let d = new Date(startDate); d < today; d.setDate(d.getDate() + 1)) {
    // const orderIdx = Math.floor(Math.random() * 1_000_000);
    orderIdx++;
    const requestedDate = new Date(d);
    requestedDate.setHours(10, 0, 0, 0);
    const expectDate = new Date(requestedDate);
    expectDate.setDate(requestedDate.getDate() + 1);

    const status = '출고완료';

    await connection.execute(
      `INSERT INTO OUTBOUND_ORDER (outbound_order_idx, franchise_idx, status, requested_date, expect_outbound_date)
       VALUES (?, ?, ?, ?, ?)`,
      [orderIdx, franchiseIdx, status, requestedDate, expectDate]
    );

    const items = generateItemsForDate(new Date(d), highVolume, orderIdx, dayIndex);
    for (const item of items) {
      await connection.execute(
        `INSERT INTO OUTBOUND_ORDER_ITEM (outbound_order_idx, product_idx, receipt_product_idx, quantity)
         VALUES (?, ?, ?, ?)`,
        item
      );
    }

    console.log(`✅ Inserted order ${orderIdx} for ${d.toISOString().slice(0, 10)}`);
    dayIndex++;
  }

  await connection.end();
  console.log('🎉 Data generation complete.');
}


// call the script here first number is for the franchise_idx second is boolean value for is franchise volume high

generateData(1, true).catch(console.error); 