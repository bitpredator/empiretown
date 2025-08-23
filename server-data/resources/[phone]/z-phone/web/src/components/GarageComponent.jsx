import React, { useContext, useState } from "react";
import { MENU_DEFAULT } from "../constant/menu";
import MenuContext from "../context/MenuContext";
import { MdArrowBackIosNew, MdClose, MdOutlineSearch } from "react-icons/md";
import { GiHomeGarage, GiPoliceBadge, GiMechanicGarage } from "react-icons/gi";
import { FaRoad } from "react-icons/fa";
import { searchByKeyValueContains } from "../utils/common";
import LoadingComponent from "./LoadingComponent";

const GarageComponent = ({ isShow }) => {
  const { resolution, setMenu, garages, setGarages, garagesBk } =
    useContext(MenuContext);
  const [isShowModal, setIsShowModal] = useState(false);
  const [dataModal, setDataModal] = useState(null);

  const getState = (typ) => {
    switch (typ) {
      case 1:
        return (
          <div className="flex space-x-1 bg-green-600 py-0.5 px-2 text-xs text-white rounded items-center">
            <span>In Garage</span>
            <GiHomeGarage />
          </div>
        );
      case 2:
        return (
          <div className="flex space-x-1 bg-red-600 py-0.5 px-2 text-xs text-white rounded items-center">
            <span>Parcheggiato</span>
            <GiPoliceBadge />
          </div>
        );
      case 3:
        return (
          <div className="flex space-x-1 bg-yellow-600 py-0.5 px-2 text-xs text-white rounded items-center">
            <span>Fuori</span>
            <FaRoad />
          </div>
        );
      default:
        return (
          <div className="flex space-x-1 bg-yellow-600 py-0.5 px-2 text-xs text-white rounded items-center">
            <span>Sequestro</span>
            <GiPoliceBadge />
          </div>
        );
    }
  };

  return (
    <div
      className="relative flex flex-col w-full h-full"
      style={{
        display: isShow ? "block" : "none",
      }}
    >
      {/* Modale informazioni veicolo */}
      <div
        className={`no-scrollbar absolute w-full z-30 overflow-auto py-10 ${
          isShowModal ? "visible" : "invisible"
        }`}
        style={{
          height: resolution.layoutHeight,
          width: resolution.layoutWidth,
          backgroundColor: "rgba(31, 41, 55, 0.8)",
        }}
      >
        <div className="flex flex-col justify-center rounded-xl h-full w-full px-3">
          <div className="bg-white rounded-lg py-2 flex flex-col w-full p-3">
            <div className="flex justify-between items-center pb-2">
              <span className="truncate font-semibold">
                {dataModal != null ? dataModal.name : ""}
              </span>
              <div>
                <MdClose
                  className="text-2xl cursor-pointer text-black hover:text-red-500"
                  onClick={() => setIsShowModal(false)}
                />
              </div>
            </div>
            {dataModal == null ? (
              <LoadingComponent />
            ) : (
              <div className="w-full">
                <img
                  src={dataModal.image}
                  alt=""
                  className="mx-auto w-28 pb-2 object-cover"
                  onError={(error) => {
                    error.target.src = "./images/noimage.jpg";
                  }}
                />
                <div className="flex flex-col gap-1 border-b py-2 text-xs">
                  <span className="flex justify-between">
                    <span className="text-gray-400">Targa:</span>
                    <span className="font-bold">{dataModal.plate}</span>
                  </span>
                  <span className="flex justify-between">
                    <span className="text-gray-400">Modello:</span>
                    <span>{dataModal.name}</span>
                  </span>
                  <span className="flex justify-between">
                    <span className="text-gray-400">Marca:</span>
                    <span>{dataModal.brand}</span>
                  </span>
                  <span className="flex justify-between">
                    <span className="text-gray-400">Categoria:</span>
                    <span>{dataModal.category}</span>
                  </span>
                  <span className="flex justify-between">
                    <span className="text-gray-400">Garage:</span>
                    <span>{dataModal.garage}</span>
                  </span>
                  <span className="flex justify-between">
                    <span className="text-gray-400">Stato:</span>
                    <span>{getState(dataModal.state)}</span>
                  </span>
                </div>
                <div className="flex flex-col gap-3 pb-2 pt-2 text-xs">
                  <span className="flex justify-between">
                    <span className="text-gray-400">Acquisto:</span>
                    <span>{dataModal.created_at}</span>
                  </span>
                  <div className=" border-b border border-dashed"></div>
                  <span className="flex justify-center space-x-2 items-center">
                    <div>
                      <GiMechanicGarage className="text-sm" />
                    </div>
                    <span>Assistenza Meccanico</span>
                  </span>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Header */}
      <div className="absolute top-0 flex w-full justify-between py-3 bg-black pt-8 z-20">
        <div
          className="flex items-center px-2 text-blue-500 cursor-pointer"
          onClick={() => setMenu(MENU_DEFAULT)}
        >
          <MdArrowBackIosNew className="text-lg" />
          <span className="text-xs">Indietro</span>
        </div>
        <span className="absolute left-0 right-0 m-auto text-sm text-white w-fit">
          Garage
        </span>
        <div className="flex items-center px-2 text-blue-500"></div>
      </div>

      {/* Lista garage */}
      {garages == undefined ? (
        <LoadingComponent />
      ) : (
        <div
          className="no-scrollbar flex flex-col w-full h-full text-white overflow-y-auto"
          style={{
            paddingTop: 60,
          }}
        >
          {/* Barra ricerca */}
          <div className="bg-black flex items-center w-full pb-3 pt-1">
            <div className="w-2"></div>
            <div className="relative w-full">
              <div className="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none">
                <MdOutlineSearch className="text-lg" />
              </div>
              <input
                type="text"
                placeholder="Cerca..."
                className="text-sm w-full text-white flex-1 border border-gray-700 focus:outline-none rounded-full px-2 py-1 pl-8 bg-[#3B3B3B]"
                autoComplete="off"
                onKeyUp={(e) => {
                  const data = searchByKeyValueContains(
                    garagesBk,
                    "name",
                    e.target.value
                  );
                  setGarages(data);
                }}
              />
            </div>
            <div className="w-2"></div>
          </div>

          {/* Card veicoli */}
          {garages.map((v, i) => {
            return (
              <div
                key={i}
                className="flex-shrink-0 mx-3 my-3 relative bg-gray-800 rounded-lg max-w-xs shadow-lg cursor-pointer"
                onClick={() => {
                  setIsShowModal(true);
                  setDataModal(v);
                }}
              >
                <div className="absolute -top-2.5 right-2 z-10">
                  {getState(v.state)}
                </div>
                <div className="relative pt-4 px-10 flex items-center justify-center">
                  <img
                    className="relative object-cover h-20"
                    src={v.image}
                    alt=""
                    onError={(error) => {
                      error.target.src = "./images/noimage.jpg";
                    }}
                  />
                </div>
                <div className="relative text-white px-2 pb-2">
                  <span className="block opacity-75 -mb-1 truncate text-sm font-semibold">
                    {v.plate}
                  </span>
                  <div className="flex justify-between items-center">
                    <span className="block font-semibold text-lg truncate">
                      {v.name}
                    </span>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};

export default GarageComponent;
