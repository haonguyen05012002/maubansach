const express = require('express');
const mysql = require('mysql');
const cors = require('cors'); 
const app = express();
const port = 3000;
const bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());

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
// API để lấy danh sách tất cả các mục trong giỏ hàng
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


// API để thêm một mục vào giỏ hàng
// API để thêm một mục vào giỏ hàng
app.post('/api/giohang', (req, res) => {
  const { id_nguoidung, id_sach } = req.body;

  if (!id_nguoidung || !id_sach) {
    return res.status(400).json({ error: 'id_nguoidung and id_sach are required.' });
  }

  const addCartItemQuery = 'INSERT INTO giohang (id_sach, id_nguoidung) VALUES (?, ?)';

  db.query(addCartItemQuery, [id_sach, id_nguoidung], (err, result) => {
    if (err) {
      console.error('Lỗi khi thêm sản phẩm vào giỏ hàng:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    // Lấy ID của mục giỏ hàng vừa được thêm vào
    const insertedId = result.insertId;

    res.json({ id: insertedId, message: 'Sản phẩm đã được thêm vào giỏ hàng.' });
  });
});


// API để xóa một mục khỏi giỏ hàng
app.delete('/api/giohang', (req, res) => {
  const { id_nguoidung, id_sach } = req.body;

  if (!id_nguoidung || !id_sach) {
    return res.status(400).json({ error: 'id_nguoidung and id_sach are required.' });
  }

  const deleteCartItemQuery = 'DELETE FROM giohang WHERE id_nguoidung = ? AND id_sach = ?';

  db.query(deleteCartItemQuery, [id_nguoidung, id_sach], (err, result) => {
    if (err) {
      console.error('Lỗi khi xóa sản phẩm khỏi giỏ hàng:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    res.json({ message: 'Sản phẩm đã được xóa khỏi giỏ hàng.' });
  });
});
//
app.get('/api/giohang/:id_nguoidung', (req, res) => {
  const { id_nguoidung } = req.params;
  const query = 'SELECT * FROM giohang WHERE id_nguoidung = ?';

  db.query(query, [id_nguoidung], (err, result) => {
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
app.post('/api/addnguoidung', (req, res) => {
  const { email, mat_khau } = req.body;

  if (!email || !mat_khau) {
    return res.status(400).json({ error: 'Email and password are required.' });
  }

  // Thêm giá trị mặc định cho id_giohang hoặc sử dụng giá trị NULL nếu không có giá trị cụ thể
  const addUserQuery = 'INSERT INTO nguoidung (email, mat_khau) VALUES (?, ?)';

  // Thay thế [email, mat_khau] bằng [email, mat_khau, gia_tri_id_giohang] trong hàm query bên dưới

  db.query(addUserQuery, [email, mat_khau], (addUserErr, addUserResult) => {
    if (addUserErr) {
      console.error('Lỗi khi thêm người dùng vào cơ sở dữ liệu:', addUserErr);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    res.json({  email });
  });
});

app.get('/api/giohang/:userId', (req, res) => {
  const userId = req.params.userId;
  const sql = 'SELECT id_sach FROM giohang WHERE id_nguoidung = ?';
  connection.query(sql, [userId], (error, results, fields) => {
    if (error) {
      console.error('Error getting cart items: ' + error.message);
      res.status(500).send('Error getting cart items from database');
      return;
    }
    res.json(results);
  });
});


app.get('/api/sach/:userId', (req, res) => {
  const userId = req.params.userId;
  const sql = 'SELECT * FROM sach WHERE id_sach IN (SELECT id_sach FROM giohang WHERE id_nguoidung = ?)';
  db.query(sql, [userId], (error, results, fields) => {
    if (error) {
      console.error('Error getting books: ' + error.message);
      res.status(500).send('Error getting books from database');
      return;
    }
    res.json(results);
  });
});
//get nguoidung qua id
app.get('/api/nguoidung/:userId', (req, res) => {
  const userId = req.params.userId;
  const sql = 'SELECT * FROM nguoidung WHERE id_nguoidung = ?';
  db.query(sql, [userId], (error, results, fields) => {
    if (error) {
      console.error('Lỗi khi lấy thông tin người dùng:', error.message);
      res.status(500).send('Lỗi khi lấy thông tin người dùng từ cơ sở dữ liệu');
      return;
    }
    res.json(results);
  });
});

app.get('/api/sach/:id_sach', (req, res) => {
  const id_sach = req.params.id_sach;
  const query = 'SELECT * FROM sach WHERE id_sach = ?';

  db.query(query, [id_sach], (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      if (result.length === 0) {
        res.status(404).json({ error: 'Sách không được tìm thấy' });
      } else {
        res.json(result[0]); // Trả về thông tin của sách đầu tiên trong kết quả
      }
    }
  });
});
app.get('/api/timsach', (req, res) => {
  const ten_sach = req.query.ten_sach; // Sử dụng req.query để lấy tham số truy vấn từ URL

  // Sử dụng dấu '?' trong query và truyền giá trị ten_sach vào mảng params
  const query = 'SELECT * FROM sach WHERE tieu_de LIKE ?';

  db.query(query, [`%${ten_sach}%`], (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn cơ sở dữ liệu:', err);
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      if (result.length === 0) {
        res.status(404).json({ error: 'Sách không được tìm thấy' });
      } else {
        res.json(result); // Trả về toàn bộ kết quả của sách thỏa mãn điều kiện
      }
    }
  });
});



//insert
// Thêm dữ liệu mẫu cho bảng binhluan
function insertSampleDataToBinhLuan() {
  const insertQuery = 'INSERT INTO binhluan (id_sach, id_nguoidung, binh_luan) VALUES (?, ?, ?)';
  const values = [
    [1, 46, 'Bình luận 1'],
    [1, 46, 'Bình luận 2'],
    [1, 46, 'Bình luận 3'],
    [1, 46, 'Bình luận 4'],
    [1, 46, 'Bình luận 5'],
  ];

  values.forEach((val) => {
    db.query(insertQuery, val, (err, result) => {
      if (err) {
        console.error('Lỗi khi chèn dữ liệu vào bảng binhluan:', err);
      } else {
        console.log('Đã chèn dữ liệu vào bảng binhluan.');
      }
    });
  });
}

// Thêm dữ liệu mẫu cho bảng giohang
function insertSampleDataToGioHang() {
  const insertQuery = 'INSERT INTO giohang (id_sach, id_nguoidung) VALUES (?, ?)';
  const values = [
    [1, 46],
    [2, 46],
    [3, 46],
    [4, 46],
    [5, 46],
  ];

  values.forEach((val) => {
    db.query(insertQuery, val, (err, result) => {
      if (err) {
        console.error('Lỗi khi chèn dữ liệu vào bảng giohang:', err);
      } else {
        console.log('Đã chèn dữ liệu vào bảng giohang.');
      }
    });
  });
}

// Thêm dữ liệu mẫu cho bảng hoadon
function insertSampleDataToHoaDon() {
  const insertQuery = 'INSERT INTO hoadon (id_nguoidung, tienthanhtoan, trangthai, hinhthuctt) VALUES (?, ?, ?, ?)';
  const values = [
    [46, 100000, 1, 'Thanh toán khi nhận hàng'],
    [46, 150000, 1, 'Thanh toán khi nhận hàng'],
    [46, 120000, 1, 'Thanh toán khi nhận hàng'],
    [46, 90000, 1, 'Thanh toán khi nhận hàng'],
    [46, 110000, 1, 'Thanh toán khi nhận hàng'],
  ];

  values.forEach((val) => {
    db.query(insertQuery, val, (err, result) => {
      if (err) {
        console.error('Lỗi khi chèn dữ liệu vào bảng hoadon:', err);
      } else {
        console.log('Đã chèn dữ liệu vào bảng hoadon.');
      }
    });
  });
}

// Thêm dữ liệu mẫu cho bảng nhaxuatban
function insertSampleDataToNhaXuatBan() {
  const insertQuery = 'INSERT INTO nhaxuatban (ten_nhaxuatban) VALUES (?)';
  const values = [
    ['Nhà xuất bản 1'],
    ['Nhà xuất bản 2'],
    ['Nhà xuất bản 3'],
    ['Nhà xuất bản 7'],
    ['Nhà xuất bản 8'],
  ];

  values.forEach((val) => {
    db.query(insertQuery, val, (err, result) => {
      if (err) {
        console.error('Lỗi khi chèn dữ liệu vào bảng nhaxuatban:', err);
      } else {
        console.log('Đã chèn dữ liệu vào bảng nhaxuatban.');
      }
    });
  });
}

// Thêm dữ liệu mẫu cho bảng nguoidung
function insertSampleDataToNguoiDung() {
  const insertQuery = 'INSERT INTO nguoidung (email, mat_khau, admin) VALUES (?, ?, ?)';
  const values = [
    ['2@gmail.com', '1', 0],
    ['3@gmail.com', '1', 0],
    ['4@gmail.com', '1', 0],
    ['5@gmail.com', '1', 0],
    ['6@gmail.com', '1', 0],
  ];

  values.forEach((val) => {
    db.query(insertQuery, val, (err, result) => {
      if (err) {
        console.error('Lỗi khi chèn dữ liệu vào bảng nguoidung:', err);
      } else {
        console.log('Đã chèn dữ liệu vào bảng nguoidung.');
      }
    });
  });
}


function insertSampleDataToSach() {
  const insertQuery = 'INSERT INTO sach (tieu_de, ngay_xuat_ban, id_theloai, mo_ta, hinh_bia, noidung, id_nhaxuatban, id_tacgia, danhgia, gia) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
  const values = [
    ['Tieu de 1', '2022-01-01', 1, 'Mo ta sach 1', 'images/image1.jpg', 'Noi dung sach 1', 1, 1, 0, 100000],
    ['Tieu de 2', '2022-01-02', 1, 'Mo ta sach 2', 'images/image2.jpg', 'Noi dung sach 2', 1, 1, 0, 150000],
    ['Tieu de 3', '2022-01-03', 1, 'Mo ta sach 3', 'images/image3.jpg', 'Noi dung sach 3', 1, 1, 0, 120000],
    ['Tieu de 4', '2022-01-04', 1, 'Mo ta sach 4', 'images/image4.jpg', 'Noi dung sach 4', 1, 1, 0, 90000],
    ['Tieu de 5', '2022-01-05', 1, 'Mo ta sach 5', 'images/image5.jpg', 'Noi dung sach 5', 1, 1, 0, 110000],
  ];

  values.forEach((val) => {
    db.query(insertQuery, val, (err, result) => {
      if (err) {
        console.error('Lỗi khi chèn dữ liệu vào bảng sach:', err);
      } else {
        console.log('Đã chèn dữ liệu vào bảng sach.');
      }
    });
  });
}

// Gọi các hàm insert dữ liệu cho từng bảng





// Khởi động server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
