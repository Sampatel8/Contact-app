var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var mysql = require('mysql');
const cors = require('cors');
const multer = require('multer')
const path = require('path');
  
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));

app.get('/', function (req, res) {
    return res.send({ error: false, message: 'Hello You Are at Contacts App' })
});
// connection configurations
var dbConn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root@123',
    database: 'contacts_app'
});

// connect to database
dbConn.connect(); 

// Retrieve all contacts 
app.get('/allcontacts', function (req, res) {
    dbConn.query('SELECT * FROM contacts', function (error, results, fields) {
        if (error) throw error;
        return res.send({ error: false, message: 'All the Contacts!', contacts: results});
    });
});

// Add a new contacts  
app.post('/addcontact', function (req, res) {
  
    let contact = req.body
    console.log(contact);
    if (!contact) {
        return res.status(400).send({ error:true, message: 'Please Provide Contact...!' });
    }
    dbConn.query("INSERT INTO contacts SET ? ", contact, function (error, results, fields) {
        if (error) throw error;
        return res.send({ error: false, message: 'New Contact has been created successfully!' });
    });
});

//  Update contact with cid
app.put('/updatecontact', function (req, res) {
  
    let contact_id = req.query.cid;
    let contact = req.body;
    console.log(contact_id)
  
    if (!contact_id || !contact) {
        return res.status(400).send({ error: user, message: 'Please provide contact and cid ...!' });
    }
    dbConn.query("UPDATE contacts SET ? WHERE cid = ?", [contact, contact_id], function (error, results, fields) {
        if (error) throw error;
        return res.send({ error: false, message: 'Contact has been updated successfully!' });
    });
});

//  Delete contact with cid
app.delete('/deletecontact', function (req, res) {
  
    let contact_id = req.body.cid;
  
    if (!contact_id) {
        return res.status(400).send({ error: true, message: 'Please provide cid ...!' });
    }
    dbConn.query('DELETE FROM contacts WHERE cid = ?', [contact_id], function (error, results, fields) {
        if (error) throw error;
        return res.send({ error: false, message: 'Contact has been updated successfully!' });
    });
}); 

// set port
app.listen(8080, function () {
    console.log('Node app is running on port 8080');
});

// serving static files
app.use('/uploads', express.static('uploads'));

// handle storage using multer
var storage = multer.diskStorage({
    dest: function (req, file, cb) {
       cb(null, "/uploads/");
    },
    filename: function (req, file, cb) {
       cb(null, `${file.fieldname}${Date.now()}${path.extname(file.originalname)}`);
    }
 });
 var upload = multer({ storage: storage });

 // handle single file upload
app.post('/uploadfile', upload.single('dataFile'), (req, res, next) => {
    const file = req.file;
    if (!file) {
       return res.status(400).send({ message: 'Please upload a file.' });
    }
    return res.send({ message: 'File uploaded successfully.', file });
 });

 
module.exports = app;