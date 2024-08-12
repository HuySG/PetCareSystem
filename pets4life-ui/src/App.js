import './App.css';
import { useState, useEffect } from 'react';
import Header from './components/Header';
import Footer from './components/Footer';
import Home from './components/Home';
import { Route, Routes, Navigate } from 'react-router-dom';
import SideBar from './components/Sidebar'
import Login from './components/Login';
import ListCustomer from './components/user/ListCustomer';
import ListStaff from './components/user/ListStaff';
import ListPet from './components/pet/ListPet';
import ListProduct from './components/product/ListProduct';
import ListService from './components/service/ListService';
import AddProduct from './components/product/AddProduct';
import AddService from './components/service/AddService';
import ListVeterinarian from './components/veterinarian/ListVeterinarian';
import ListAppointment from './components/appoinment/ListAppointments';
import PrivateRoute from './components/PrivateRoute';
import AddStaff from './components/user/AddStaff';
import EditProduct from './components/product/EditProduct';
import EditService from './components/service/EditService';
import EditStaff from './components/user/EditStaff';
import AddVeterinarian from './components/veterinarian/AddVeterinarian';
import EditVeterinarian from './components/veterinarian/EditVeterinarian';
import ListOrder from './components/order/ListOrder';
import OrderDetail from './components/order/OrderDetail';
import EditAppointment from './components/appoinment/EditAppointment';
import EditOrder from './components/order/EditOrder';
import EditPet from './components/pet/EditPet';

function App() {

  const [isLoggedIn, setIsLoggedIn] = useState(false); // Add a state for login status

  useEffect(() => {
    // Check if the user is already logged in by retrieving the login status from local storage
    const storedLoginStatus = localStorage.getItem('isLoggedIn');
    setIsLoggedIn(storedLoginStatus === 'true');

  }, []);

  return (
    <>
    
      <Routes>
        <Route path="/" element={<Navigate to="/login" />} />
        <Route
          path="/login"
          element={<Login setIsLoggedIn={setIsLoggedIn} />} // Pass setIsLoggedIn prop to Login component
        />
        <Route path="/home" element={isLoggedIn ? (<Home />) : (<Navigate to="/login" replace={true} />)} />
        <Route path="/list_customers" element={isLoggedIn ? (<ListCustomer />) : (<Navigate to="/login" replace={true} />)} />
        <Route path="/list_staffs" element={isLoggedIn ? (<ListStaff />) : (<Navigate to="/login" replace={true} />)} />
        <Route path="/add_staff" element={isLoggedIn ? (<AddStaff />) : (<Navigate to="/login" replace={true} />)} />
        <Route path='/edit_staff/:userId' element={<EditStaff />}></Route>
        <Route path="/list_pets" element={isLoggedIn ? (<ListPet />) : (<Navigate to="/login" replace={true} />)} />
        <Route path='/edit_pet/:petId' element={<EditPet />}></Route>
        <Route path="/list_products" element={isLoggedIn ? (<ListProduct />) : (<Navigate to="/login" replace={true} />)} />
        <Route path="/add_product" element={isLoggedIn ? (<AddProduct />) : (<Navigate to="/login" replace={true} />)} />
        <Route path='/edit_product/:productId' element={<EditProduct />}></Route>
        <Route path="/list_services" element={isLoggedIn ? (<ListService />) : (<Navigate to="/login" replace={true} />)} />
        <Route path="/add_service" element={isLoggedIn ? (<AddService />) : (<Navigate to="/login" replace={true} />)} />
        <Route path='/edit_service/:serviceId' element={<EditService />}></Route>
        <Route path="/list_veterinarians" element={isLoggedIn ? (<ListVeterinarian />) : (<Navigate to="/login" replace={true} />)} />
        <Route path="/add_veterinarian" element={isLoggedIn ? (<AddVeterinarian />) : (<Navigate to="/login" replace={true} />)} />
        <Route path='/edit_veterinarian/:vetId' element={<EditVeterinarian />}></Route>
        <Route path='/edit_appointment/:appointmentId' element={<EditAppointment />}></Route>
        <Route path="/list_appointments" element={isLoggedIn ? (<ListAppointment />) : (<Navigate to="/login" replace={true} />)} />
        <Route path="/list_orders" element={isLoggedIn ? (<ListOrder />) : (<Navigate to="/login" replace={true} />)} />
        <Route path='/edit_order/:orderId' element={<EditOrder />}></Route>
        <Route path='/detail_order/:orderId' element={<OrderDetail />}></Route>

      </Routes>

    </>
  );
}

export default App;
