const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 3000;

// Kết nối đến cơ sở dữ liệu
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Thay thế bằng tên người dùng của bạn
  password: '', // Thay thế bằng mật khẩu của bạn
  database: 'ebooks',
});

db.connect((err) => {
  if (err) {
    console.error('Không thể kết nối đến cơ sở dữ liệu:', err);
  } else {
    console.log('Đã kết nối đến cơ sở dữ liệu');
  }
});

// Route mẫu để lấy danh sách sách
app.get('/api/sach', (req, res) => {
  const query = 'SELECT * FROM sach';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Route mẫu để lấy danh sách tác giả
app.get('/api/tacgia', (req, res) => {
  const query = 'SELECT * FROM tacgia';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Route mẫu để lấy danh sách bình luận
app.get('/api/binhluan', (req, res) => {
  const query = 'SELECT * FROM binhluan';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Route mẫu để lấy danh sách nhà xuất bản
app.get('/api/nhaxuatban', (req, res) => {
  const query = 'SELECT * FROM nhaxuatban';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Route mẫu để lấy danh sách giỏ hàng
app.get('/api/giohang', (req, res) => {
  const query = 'SELECT * FROM giohang';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Route mẫu để lấy danh sách người dùng
app.get('/api/nguoidung', (req, res) => {
  const query = 'SELECT * FROM nguoidung';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Route mẫu để lấy danh sách thể loại
app.get('/api/theloai', (req, res) => {
  const query = 'SELECT * FROM theloai';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Route mẫu để lấy danh sách voucher
app.get('/api/voucher', (req, res) => {
  const query = 'SELECT * FROM voucher';

  db.query(query, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.json(result);
    }
  });
});
// Khởi động server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
