import React, { useEffect, useState } from 'react';
import SideBar from '../Sidebar';
import Header from '../Header';
import { useNavigate, useParams } from 'react-router-dom';
import orderService from '../../services/order.service';
import storage from '../../firebaseConfig';
import { ref, uploadBytesResumable, getDownloadURL } from "firebase/storage";

const EditOrder = () => {
    const [order, setOrder] = useState({
        orderId: null, // Initialize orderId as null or a default value
        isPaid: 1, // Set the initial value of isPaid as needed (as a string)
        imagePayment: ""
    });


    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState('');
    const navigate = useNavigate();

    const handleChange = (e) => {
        const value = e.target.value;
        setOrder({ ...order, [e.target.name]: value });
        

    };

    const { orderId } = useParams();

    // Image preview
    const [imagePreview, setImagePreview] = useState(null);

    const [showImage, setShowImage] = useState(true); // Initially, show the image


    //image
    const [file, setFile] = useState("");
    // progress
    const [percent, setPercent] = useState(0);

    // Handle file upload event and update state
    function handleImageChange(event) {
        const selectedFile = event.target.files[0];
        setFile(selectedFile);
        // product.image = event.target.files[0]
        // handleUpload();

        // Update the image preview
        const reader = new FileReader();
        reader.onload = (e) => {
            setImagePreview(e.target.result);
        };
        reader.readAsDataURL(selectedFile);

    }
    var link = "";

    const handleUpload = () => {
        if (!file) {
            alert("Please upload an image first!");
        }

        const storageRef = ref(storage, `/files/${file.name}`);

        // progress can be paused and resumed. It also exposes progress updates.
        // Receives the storage reference and the file to upload.
        const uploadTask = uploadBytesResumable(storageRef, file);

        uploadTask.on(
            "state_changed",
            (snapshot) => {
                const percent = Math.round(
                    (snapshot.bytesTransferred / snapshot.totalBytes) * 100
                );

                // update progress
                setPercent(percent);
            },
            (err) => console.log(err),
            () => {
                // download url

                getDownloadURL(uploadTask.snapshot.ref)
                    .then((url) => {
                        console.log("File available at:", url);
                        //gan url vao link local
                        link = url;

                        order.imagePayment = link;

                        // Hide the image after uploading
                        setShowImage(false);

                    })
                    .catch((error) => {
                        console.error("Error getting download URL:", error);
                    });
            }
        );
    };

    useEffect(() => {
        if (orderId) {
            orderService
                .getOrder(orderId)
                .then((res) => {
                    console.log('day la Order: ', res.data);
                    // Format the date to YYYY-MM-DD
                    setOrder(res.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }, [orderId]);

    const validateForm = () => {
        let isValid = true;
        const errors = {};

        setErrors(errors);
        return isValid;
    };



    const submitOrder = (e) => {
        e.preventDefault();

        if (validateForm()) {
            console.log('day la Order: ', order);
            if(order.isPaid === 'true'){
                order.isPaid = true;
              
            }
            if(order.isPaid === 'false'){
                order.isPaid = false;
            }
            orderService
                .updateOrder(order.orderId, order)
                .then((res) => {
                    if (order.isPaid === true) {
                        sendEmail();
                    }
                    navigate("/list_orders/");
                })
                .catch((error) => {
                    console.log(error);
                    console.log('day la Order sai: ', order);
                    console.log('day la Order sai: ', order.isPaid);

                });

        }
    };

    const sendEmail = () => {
        orderService.sendEmailAppointment(order.userId);
    };


    return (
        <>
            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                <div id="content-wrapper" className="d-flex flex-column" style={{ backgroundImage: `url(/banner2.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    <div id="content">
                        <Header />
                        <div className="container-fluid">
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Update Order: {orderId}</h1>

                            <form onSubmit={(e) => submitOrder(e)}>
                                <div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Is Paid?</label>
                                        <select
                                            name="isPaid"
                                            value={order.isPaid} // Keep it as a boolean, not 'true' or 'false' string
                                            onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.order ? 'is-invalid' : ''}`}
                                            id="exampleInputPassword1"
                                        >
                                            <option value={true}>Yes</option>
                                            <option value={false}>Not Yet</option>
                                        </select>
                                    </div>




                                    {showImage && (
                                        <div className="form-group">
                                            <img src={order.imagePayment}  width="100" height="100" />
                                        </div>
                                    )}


                                    <div className="form-group">
                                        <input type="file" onChange={handleImageChange} accept="/image/*" />
                                        <button type="button" className='btn btn-dark' onClick={handleUpload}><i class="fas fa-bolt"></i> Select</button>
                                        <p>{percent} "% done"</p>
                                    </div>

                                    {/* Image preview */}
                                    {imagePreview && (
                                        <div className="form-group">
                                            <img src={imagePreview} alt="Image Preview" style={{ width: 160, height: 100 }} />
                                        </div>
                                    )}


                                    <button type="submit" className="btn btn-custom" style={{ backgroundColor: "#000" }}><i class="fas fa-check-circle text-warning"></i></button>


                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
};

export default EditOrder;