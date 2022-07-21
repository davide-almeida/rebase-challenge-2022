require 'spec_helper'

describe 'Trying use tasks' do
  let(:app) { Server.new }

  it 'drop database' do
    @conn = ConnectDatabase.connection
    ApplicationModels.create_all_tables

    Rake::Task['database:db_drop'].execute

    tables = @conn.exec("select table_name from information_schema.tables where table_schema='public'")
    table_list = []
    tables.each do |table|
      table_list << table.values[0]
    end

    expect(table_list).not_to include 'clients'
    expect(table_list).not_to include 'doctors'
    expect(table_list).not_to include 'tests'
  end

  it 'create database' do
    @conn = ConnectDatabase.connection
    Rake::Task['database:db_drop'].execute
    Rake::Task['database:db_client'].execute
    Rake::Task['database:db_doctor'].execute
    Rake::Task['database:db_test'].execute

    tables = @conn.exec("select table_name from information_schema.tables where table_schema='public'")
    table_list = []
    tables.each do |table|
      table_list << table.values[0]
    end

    expect(table_list).to include 'clients'
    expect(table_list).to include 'doctors'
    expect(table_list).to include 'tests'
  end

  it 'populate database' do
    @conn = ConnectDatabase.connection
    Rake::Task['database:db_drop'].execute
    Rake::Task['database:db_client'].execute
    Rake::Task['database:db_doctor'].execute
    Rake::Task['database:db_test'].execute
    Rake::Task['seed_database:db_insert'].execute

    all_clients = Client.all
    all_doctors = Doctor.all
    all_tests = Test.all

    expect(all_tests.count).to eq 3900
    expect(all_doctors.count).to eq 10
    expect(all_clients.count).to eq 50
  end
end
