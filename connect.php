<?php
$server = "localhost"; // เซิร์ฟเวอร์ MySQL
$username = "root"; // ชื่อผู้ใช้ MySQL
$password = ""; // รหัสผ่าน MySQL
$database = "flutter_project"; // ชื่อฐานข้อมูลที่คุณต้องการเชื่อมต่อ

// สร้างการเชื่อมต่อ
$conn = new mysqli($server, $username, $password, $database);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("การเชื่อมต่อล้มเหลว: " . $conn->connect_error);
}

// คุณสามารถใช้ $conn เพื่อทำการเชื่อมต่อกับฐานข้อมูลและทำการส่งคำสั่ง SQL ต่าง ๆ ไปยัง MySQL ตามความต้องการของคุณ
?>
