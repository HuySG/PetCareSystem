import React, { useEffect, useState } from 'react';
import Header from '../Header';
import SideBar from '../Sidebar';
import { Link } from 'react-router-dom';
import ReactPaginate from 'react-paginate';
import OrderService from '../../services/order.service';
import { useNavigate, useParams } from 'react-router-dom';
import productService from '../../services/product.service';
import serviceService from '../../services/service.service';
import {AiFillCaretLeft, AiFillCaretRight } from "react-icons/ai"; // icons form react-icons
import { IconContext } from "react-icons"; // for customizing icons
import "../../../src/my-styles.css"



const OrderDetail = () => {

    const [OrderList, setOrderList] = useState([]);
    const [msg, setMsg] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(0);
    const [OrdersPerPage] = useState(5);

    const [productNames, setProductNames] = useState({}); // Store product names
    const [serviceNames, setserviceNames] = useState({}); // Store product names


    const { orderId } = useParams();

    useEffect(() => {
        if (orderId) {
            OrderService
                .getOrderDetailByOrderId(orderId)
                .then((res) => {
                    console.log(res.data);
                    setOrderList(res.data);

                    const productId = res.data.map((order) => order.productId);
                    const serviceId = res.data.map((order) => order.serviceId);
                    fetchProductNames(productId);
                    fetchServiceNames(serviceId);


                })
                .catch((error) => {
                    console.log(error);
                });
        }

    }, [orderId]);

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
    };

    const fetchProductNames = (productIds) => {
        const productPromises = productIds.map((productId) =>
            productService.getProductById(productId)
                .then((res) => {
                    // Store the entire product object in productNames state using the productId as the key
                    setProductNames((prevState) => ({
                        ...prevState,
                        [productId]: res.data,
                    }));
                })
                .catch((error) => {
                    console.log(error);
                })
        );

        Promise.all(productPromises)
            .then(() => {
                // All product objects have been fetched and stored in productNames state
                console.log('Product names fetched:', productNames);
            })
            .catch((error) => {
                console.log(error);
            });
    };

    const fetchServiceNames = (serviveIds) => {
        const servicePromises = serviveIds.map((serviceId) =>
            serviceService.getServiceById(serviceId)
                .then((res) => {
                    // Store the entire product object in productNames state using the productId as the key
                    setserviceNames((prevState) => ({
                        ...prevState,
                        [serviceId]: res.data,
                    }));
                })
                .catch((error) => {
                    console.log(error);
                })
        );

        Promise.all(servicePromises)
            .then(() => {
                // All product objects have been fetched and stored in productNames state
                console.log('Service names fetched:', serviceNames);
            })
            .catch((error) => {
                console.log(error);
            });
    };


    const filteredOrders = OrderList
        .filter((Order) => {
            return (
                Order.orderDetailId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                Order.orderId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                Order.productId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                Order.serviceId.toString().toLowerCase().includes(searchTerm.toLowerCase())
            );
        });

    const pageCount = Math.ceil(filteredOrders.length / OrdersPerPage);

    const handlePageClick = (data) => {
        setCurrentPage(data.selected);
    };

    const offset = currentPage * OrdersPerPage;
    const currentOrders = filteredOrders.slice(offset, offset + OrdersPerPage);

    return (
        <>
            {/* Page Wrapper */}
            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                {/* Content Wrapper */}
                <div id="content-wrapper" className="d-flex flex-column" style={{ backgroundImage: `url(/banner2.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    {/* Main Content */}
                    <div id="content">
                        <Header />
                        <div className="container-fluid">
                            {/* Page Heading */}
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert" , color: "#000", fontSize: "20px"}}>Detail Order:  {orderId}</h1>

                            {msg && <p className="text-center text-success">{msg}</p>}

                            <div className="card shadow mb-4">
                                <div className="card-body">
                                    <div className="table-responsive">
                                        <table className="table table-bordered" id="" width="100%" cellSpacing="0">
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th>Service</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {currentOrders.map((cus) => (
                                                    <tr key={cus.orderDetailId}>
                                                        <td>{productNames[cus.productId]?.productName}</td>
                                                        <td>{serviceNames[cus.serviceId]?.serviceName}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            {/* Pagination */}
                            <div className='container-fluid'>
                                {/* Pagination */}
                                <div style={{ display: 'flex', justifyContent: 'center' }}>
                                    <ReactPaginate
                                        previousLabel={
                                            <IconContext.Provider value={{ color: "#000", size: "23px" }}>
                                                <AiFillCaretLeft />
                                            </IconContext.Provider>
                                        }
                                        nextLabel={
                                            <IconContext.Provider value={{ color: "#000", size: "23px" }}>
                                                <AiFillCaretRight />
                                            </IconContext.Provider>
                                        } breakLabel={'...'}
                                        breakClassName={'page-item'}
                                        breakLinkClassName={'page-link'}
                                        pageCount={pageCount}
                                        marginPagesDisplayed={2}
                                        pageRangeDisplayed={5}
                                        onPageChange={handlePageClick}
                                        containerClassName={'pagination'}
                                        activeClassName={'active'}
                                        previousClassName={'page-item'}
                                        nextClassName={'page-item'}
                                        pageClassName={'page-item'}
                                        previousLinkClassName={'page-link'}
                                        nextLinkClassName={'page-link'}
                                        pageLinkClassName={'page-link'}
                                    />
                                </div>

                            </div>
                        </div>
                        {/* /.container-fluid */}
                    </div>
                </div>
            </div>
        </>
    );
}

export default OrderDetail